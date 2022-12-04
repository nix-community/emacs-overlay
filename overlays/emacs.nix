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

        (drv: drv.override ({ srcRepo = true; } // builtins.removeAttrs args [ "noTreeSitter" ]))

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
      ++ (super.lib.optional (! (args ? "noTreeSitter")) (
        drv: drv.overrideAttrs (old:
          let
            libName = drv: super.lib.removeSuffix "-grammar" drv.pname;
            libSuffix = if super.stdenv.isDarwin then "dylib" else "so";
            lib = drv: ''lib${libName drv}.${libSuffix}'';
            linkCmd = drv:
              if super.stdenv.isDarwin
              then ''cp ${drv}/parser $out/lib/${lib drv}
                     # FIXME: Is this kosher?
                     /usr/bin/install_name_tool -id $out/lib/${lib drv} $out/lib/${lib drv}
                     /usr/bin/codesign -s - -f $out/lib/${lib drv}
                ''
              else ''ln -s ${drv}/parser $out/lib/${lib drv}'';
            linkerFlag = drv: "-l" + libName drv;
            plugins = with self.pkgs.tree-sitter-grammars; [
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
            ];
            tree-sitter-grammars = super.runCommand "tree-sitter-grammars" {}
              (super.lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
          in {
            buildInputs = old.buildInputs ++ [ self.pkgs.tree-sitter tree-sitter-grammars ];
            # before building the `.el` files, we need to allow the `tree-sitter` libraries
            # bundled in emacs to be dynamically loaded.
            TREE_SITTER_LIBS = super.lib.concatStringsSep " " ([ "-ltree-sitter" ] ++ (map linkerFlag plugins));
            # Add to directories that tree-sitter looks in for language definitions / shared object parsers
            # FIXME: This was added for macOS, but it shouldn't be necessary on any platform.
            # https://git.savannah.gnu.org/cgit/emacs.git/tree/src/treesit.c?h=64044f545add60e045ff16a9891b06f429ac935f#n533
            # appends a bunch of filenames that appear to be incorrectly skipped over
            # in https://git.savannah.gnu.org/cgit/emacs.git/tree/src/treesit.c?h=64044f545add60e045ff16a9891b06f429ac935f#n567
            # on macOS, but are handled properly in Linux.
            postPatch = old.postPatch + super.lib.optionalString super.stdenv.isDarwin ''
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

  emacsPgtk = mkPgtkEmacs "emacs-pgtk" ../repos/emacs/emacs-master.json { withSQLite3 = true; withWebP = true; withGTK3 = true; };

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
