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

        (drv: drv.override ({ srcRepo = true; } // builtins.removeAttrs args [ "noTreeSitter" "treeSitterPlugins" ]))

        (
          drv: drv.overrideAttrs (
            old: {
              name = "${namePrefix}-${repoMeta.version}";
              inherit (repoMeta) version;
              src = fetcher (builtins.removeAttrs repoMeta [ "type" "version" ]);

              patches = [ ];

              # fixes segfaults that only occur on aarch64-linux (issue#264)
              configureFlags = old.configureFlags ++
                               super.lib.optionals (super.stdenv.isLinux && super.stdenv.isAarch64)
                                 [ "--enable-check-lisp-object-type" ];

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
      ++ (super.lib.optional (! (args ? "noTreeSitter")) (
        drv: drv.overrideAttrs (old:
          let
            libName = drv: super.lib.removeSuffix "-grammar" drv.pname;
            libSuffix = if super.stdenv.isDarwin then "dylib" else "so";
            lib = drv: ''lib${libName drv}.${libSuffix}'';
            linkCmd = drv:
              if super.stdenv.isDarwin
              then ''cp ${drv}/parser .
                     chmod +w ./parser
                     install_name_tool -id $out/lib/${lib drv} ./parser
                     cp ./parser $out/lib/${lib drv}
                     /usr/bin/codesign -s - -f $out/lib/${lib drv}
                ''
              else ''ln -s ${drv}/parser $out/lib/${lib drv}'';
            plugins = args.treeSitterPlugins;
            tree-sitter-grammars = super.runCommandCC "tree-sitter-grammars" {}
              (super.lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
          in {
            buildInputs = old.buildInputs ++ [ self.pkgs.tree-sitter tree-sitter-grammars ];
            buildFlags = super.lib.optionalString self.stdenv.isDarwin
              "LDFLAGS=-Wl,-rpath,${super.lib.makeLibraryPath [tree-sitter-grammars]}";
            TREE_SITTER_LIBS = "-ltree-sitter";
            # Add to list of directories dlopen/dynlib_open searches for tree sitter languages *.so
            postFixup = old.postFixup + super.lib.optionalString self.stdenv.isLinux ''
                ${self.pkgs.patchelf}/bin/patchelf --add-rpath ${super.lib.makeLibraryPath [ tree-sitter-grammars ]} $out/bin/emacs
              '';
          }
        )
      )));

  defaultTreeSitterPlugins = with self.pkgs.tree-sitter-grammars; [
    tree-sitter-bash
    tree-sitter-c
    tree-sitter-c-sharp
    tree-sitter-cmake
    tree-sitter-cpp
    tree-sitter-css
    tree-sitter-dockerfile
    tree-sitter-go
    tree-sitter-gomod
    tree-sitter-java
    tree-sitter-javascript
    tree-sitter-json
    tree-sitter-python
    tree-sitter-ruby
    tree-sitter-rust
    tree-sitter-toml
    tree-sitter-tsx
    tree-sitter-typescript
    tree-sitter-yaml
  ];

  emacsGit = super.lib.makeOverridable (mkGitEmacs "emacs-git" ../repos/emacs/emacs-master.json) { withSQLite3 = true; withWebP = true; treeSitterPlugins = defaultTreeSitterPlugins; };

  emacsPgtk = super.lib.makeOverridable (mkGitEmacs "emacs-pgtk" ../repos/emacs/emacs-master.json) { withSQLite3 = true; withWebP = true; withPgtk = true; treeSitterPlugins = defaultTreeSitterPlugins; };

  emacsUnstable = (mkGitEmacs "emacs-unstable" ../repos/emacs/emacs-unstable.json { noTreeSitter = true; });

  emacsLsp = (mkGitEmacs "emacs-lsp" ../repos/emacs/emacs-lsp.json { noTreeSitter = true; });

in
{
  inherit emacsGit emacsUnstable;

  inherit emacsPgtk;

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

  inherit emacsLsp;

  emacsWithPackagesFromUsePackage = import ../elisp.nix { pkgs = self; };

  emacsWithPackagesFromPackageRequires = import ../packreq.nix { pkgs = self; };

} // super.lib.optionalAttrs (super.config.allowAliases or true) {
  emacsGcc = builtins.trace "emacsGcc has been renamed to emacsGit, please update your expression." emacsGit;
  emacsGitNativeComp = builtins.trace "emacsGitNativeComp has been renamed to emacsGit, please update your expression." emacsGit;
  emacsGitTreeSitter = builtins.trace "emacsGitTreeSitter has been renamed to emacsGit, please update your expression." emacsGit;
  emacsNativeComp = builtins.trace "emacsNativeComp has been renamed to emacsUnstable, please update your expression." emacsUnstable;
  emacsPgtkGcc = builtins.trace "emacsPgtkGcc has been renamed to emacsPgtk, please update your expression." emacsPgtk;
  emacsPgtkNativeComp = builtins.trace "emacsPgtkNativeComp has been renamed to emacsPgtk, please update your expression." emacsPgtk;
}
