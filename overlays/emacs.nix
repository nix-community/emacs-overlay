self: super:
let
  mkGitEmacs = namePrefix: jsonFile: { ... }@args:
    let
      repoMeta = super.lib.importJSON jsonFile;
      fetcher =
        if repoMeta.type == "savannah" then
          super.fetchFromSavannah
        else if repoMeta.type == "github" then
          super.fetchFromGitHub
        else
          throw "Unknown repository type ${repoMeta.type}!";
    in
    builtins.foldl'
      (drv: fn: fn drv)
      super.emacs
      ([

        (drv: drv.override ({ srcRepo = true; } // builtins.removeAttrs args [ "withTreeSitterPlugins" "withTreeSitter" ]))

        (
          drv: drv.overrideAttrs (
            old: {
              name = "${namePrefix}-${repoMeta.version}";
              inherit (repoMeta) version;
              src = fetcher (builtins.removeAttrs repoMeta [ "type" "version" ]);

              patches = [ ];

              postPatch = old.postPatch + ''
                substituteInPlace lisp/loadup.el \
                --replace '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
                --replace '(emacs-repository-get-branch)' '"master"'
              '' +
              # XXX: remove when https://github.com/NixOS/nixpkgs/pull/193621 is merged
                (super.lib.optionalString (old ? NATIVE_FULL_AOT)
                    (let backendPath = (super.lib.concatStringsSep " "
                      (builtins.map (x: ''\"-B${x}\"'') [
                        # Paths necessary so the JIT compiler finds its libraries:
                        "${super.lib.getLib self.libgccjit}/lib"
                        "${super.lib.getLib self.libgccjit}/lib/gcc"
                        "${super.lib.getLib self.stdenv.cc.libc}/lib"

                        # Executable paths necessary for compilation (ld, as):
                        "${super.lib.getBin self.stdenv.cc.cc}/bin"
                        "${super.lib.getBin self.stdenv.cc.bintools}/bin"
                        "${super.lib.getBin self.stdenv.cc.bintools.bintools}/bin"
                      ]));
                     in ''
                        substituteInPlace lisp/emacs-lisp/comp.el --replace \
                            "(defcustom comp-libgccjit-reproducer nil" \
                            "(setq native-comp-driver-options '(${backendPath}))
(defcustom comp-libgccjit-reproducer nil"
                    ''));
            }
          )
        )

        # reconnect pkgs to the built emacs
        (
          drv:
          let
            result = drv.overrideAttrs (old: {
              passthru = old.passthru // {
                pkgs = self.emacsPackagesFor result;
              };
            });
          in
          result
        )
      ]
      ++ (super.lib.optional (args ? "withTreeSitter") (
        drv: drv.overrideAttrs (old:
          let
            libName = drv: super.lib.removeSuffix "-grammar" drv.pname;
            libSuffix = if super.stdenv.isDarwin then "dylib" else "so";
            lib = drv: ''lib${libName drv}.${libSuffix}'';
            # /usr/bin/codesign --deep -s - -f $out/lib/${lib drv}
            linkCmd = drv:
              if super.stdenv.isDarwin
              then ''cp ${drv}/parser $out/lib/${lib drv}
                     /usr/bin/install_name_tool -id $out/lib/${lib drv} $out/lib/${lib drv}''
              else ''ln -s ${drv}/parser $out/lib/${lib drv}'';
            linkerFlag = drv: "-l" + libName drv;

            plugins = args.withTreeSitterPlugins self.pkgs.tree-sitter-grammars;
            tree-sitter-grammars = super.runCommand "tree-sitter-grammars" {}
              (super.lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
          in {
            buildInputs = old.buildInputs ++ [ self.pkgs.tree-sitter tree-sitter-grammars ];
            # before building the `.el` files, we need to allow the `tree-sitter` libraries
            # bundled in emacs to be dynamically loaded.
            TREE_SITTER_LIBS = super.lib.concatStringsSep " " ([ "-ltree-sitter" ] ++ (map linkerFlag plugins));
            # Fixes tree sitter error: "Buffer has no parser"
            # Configure emacs where libraries exist nix store.
            postPatch = old.postPatch + ''
                 substituteInPlace src/treesit.c \
                 --replace "Vtreesit_extra_load_path = Qnil;" \
                           "Vtreesit_extra_load_path = list1 ( build_string ( \"${tree-sitter-grammars}/lib\" ) );"
            '';
          }
        )
      )));


  mkPgtkEmacs = namePrefix: jsonFile: { ... }@args: (mkGitEmacs namePrefix jsonFile args).overrideAttrs (
    old: {
      configureFlags = (super.lib.remove "--with-xft" old.configureFlags)
        ++ super.lib.singleton "--with-pgtk";
    }
  );

  emacsGit = mkGitEmacs "emacs-git" ../repos/emacs/emacs-master.json { withSQLite3 = true; withWebP = true; };

  emacsNativeComp = super.emacsNativeComp or (mkGitEmacs "emacs-native-comp" ../repos/emacs/emacs-unstable.json { nativeComp = true; });

  emacsGitNativeComp = mkGitEmacs "emacs-git-native-comp" ../repos/emacs/emacs-master.json {
    withSQLite3 = true;
    withWebP = true;
    nativeComp = true;
  };

  emacsPgtk = mkPgtkEmacs "emacs-pgtk" ../repos/emacs/emacs-master.json { withSQLite3 = true; withGTK3 = true; };

  emacsPgtkNativeComp = mkPgtkEmacs "emacs-pgtk-native-comp" ../repos/emacs/emacs-master.json { nativeComp = true; withSQLite3 = true; withGTK3 = true; };

  emacsUnstable = (mkGitEmacs "emacs-unstable" ../repos/emacs/emacs-unstable.json { });

  emacsGitTreeSitter = super.lib.makeOverridable (mkGitEmacs "emacs-git" ../repos/emacs/emacs-master.json) {
    withTreeSitter = true;
    withTreeSitterPlugins = (plugins: with plugins; [
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-c-sharp
      tree-sitter-cpp
      tree-sitter-css
      tree-sitter-java
      tree-sitter-python
      tree-sitter-javascript
      tree-sitter-json
      tree-sitter-tsx
      tree-sitter-typescript
      tree-sitter-clojure
    ]);
  };

  emacsLsp = (mkGitEmacs "emacs-lsp" ../repos/emacs/emacs-lsp.json { nativeComp = true; });

in
{
  inherit emacsGit emacsUnstable;

  inherit emacsNativeComp emacsGitNativeComp;

  inherit emacsPgtk emacsPgtkNativeComp;

  emacsGit-nox = (
    (
      emacsGit.override {
        withNS = false;
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
        withWebP = false;
      }
    ).overrideAttrs (
      oa: {
        name = "${oa.name}-nox";
      }
    )
  );

  emacsUnstable-nox = (
    (
      emacsUnstable.override {
        withNS = false;
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
        withWebP = false;
      }
    ).overrideAttrs (
      oa: {
        name = "${oa.name}-nox";
      }
    )
  );

  inherit emacsGitTreeSitter;

  inherit emacsLsp;

  emacsWithPackagesFromUsePackage = import ../elisp.nix { pkgs = self; };

  emacsWithPackagesFromPackageRequires = import ../packreq.nix { pkgs = self; };

} // super.lib.optionalAttrs (super.config.allowAliases or true) {
  emacsGcc = builtins.trace "emacsGcc has been renamed to emacsNativeComp, please update your expression." emacsNativeComp;
  emacsPgtkGcc = builtins.trace "emacsPgtkGcc has been renamed to emacsPgtkNativeComp, please update your expression." emacsPgtkNativeComp;
}
