self: super: let
  inherit
    (super.emacs-overlay)
    mkEmacsFromRepo
    enableTreeSitterWith
    enablePgtk
    enableNativeCompilation
    repos
    ;

  emacsGit =
    (mkEmacsFromRepo {
      name = "emacs-git";
      repository = repos.emacs.master;
      features = [
        enableNativeCompilation
        (enableTreeSitterWith
          (p:
            with p; [
              tree-sitter-bash
              tree-sitter-c
              tree-sitter-c-sharp
              tree-sitter-cmake
              tree-sitter-cpp
              tree-sitter-css
              tree-sitter-dockerfile
              tree-sitter-java
              tree-sitter-python
              tree-sitter-javascript
              tree-sitter-json
              tree-sitter-tsx
              tree-sitter-typescript
            ]))
      ];
    })
    .override {
      withSQLite3 = true;
      withWebP = true;
    };

  emacsPgtk =
    (mkEmacsFromRepo {
      name = "emacs-pgtk";
      repository = repos.emacs.master;
      features = [
        enableNativeCompilation
        enablePgtk
      ];
    })
    .override {
      withSQLite3 = true;
      withWebP = true;
      withGTK3 = true;
    };

  emacsUnstable = mkEmacsFromRepo {
    name = "emacs-unstable";
    repository = repos.emacs.unstable;
    features = [
      enableNativeCompilation
    ];
  };

  emacsLsp = mkEmacsFromRepo {
    name = "emacs-lsp";
    repository = repos.emacs.lsp;
    features = [
      enableNativeCompilation
    ];
  };
in
  {
    inherit emacsGit emacsUnstable emacsPgtk emacsLsp;

    emacsGit-nox = (
      (
        emacsGit.override {
          withNS = false;
          withX = false;
          withGTK2 = false;
          withGTK3 = false;
          withWebP = false;
        }
      )
      .overrideAttrs (
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
      )
      .overrideAttrs (
        oa: {
          name = "${oa.name}-nox";
        }
      )
    );

    emacsWithPackagesFromUsePackage = import ../elisp.nix {pkgs = self;};

    emacsWithPackagesFromPackageRequires = import ../packreq.nix {pkgs = self;};
  }
  // super.lib.optionalAttrs (super.config.allowAliases or true) {
    emacsGcc = builtins.trace "emacsGcc has been renamed to emacsGit, please update your expression." emacsGit;
    emacsGitNativeComp = builtins.trace "emacsGitNativeComp has been renamed to emacsGit, please update your expression." emacsGit;
    emacsGitTreeSitter = builtins.trace "emacsGitTreeSitter has been renamed to emacsGit, please update your expression." emacsGit;
    emacsNativeComp = builtins.trace "emacsNativeComp has been renamed to emacsUnstable, please update your expression." emacsUnstable;
    emacsPgtkGcc = builtins.trace "emacsPgtkGcc has been renamed to emacsPgtk, please update your expression." emacsPgtk;
    emacsPgtkNativeComp = builtins.trace "emacsPgtkNativeComp has been renamed to emacsPgtk, please update your expression." emacsPgtk;
  }
