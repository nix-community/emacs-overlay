self: super: let
  inherit (self) emacs emacsPackagesFor;
  inherit
    (super)
    pkgs
    callPackage
    stdenv
    lib
    ;

  # reconnect pkgs to the built emacs
  forwardPkgs = drv:
    drv.overrideAttrs (old: {
      passthru =
        old.passthru
        // {
          pkgs = emacsPackagesFor drv;
        };
    });
in {
  emacs-overlay =
    (super.emacs-overlay or {})
    // rec {
      # Override an existing Emacs derivation with features (defined
      # below).
      #
      # Only overrides the Elisp packages provided by emacs-overlay. To
      # override the source of Emacs use `mkEmacsFromRepo`.
      mkEmacsWithFeatures = features:
        builtins.foldl'
        (drv: fn: fn drv)
        emacs
        (features ++ [forwardPkgs]);

      # Override an Emacs derivation with a custom source defined in
      # emacs-overlay (see repos/default.nix for defined repositories).
      #
      # Example mkEmacsFromRepo { name = "test"; repo = emacs-overlay.repos.emacs.master; }
      mkEmacsFromRepo = {
        name,
        features ? [],
        repository,
      }: let
        setSource = drv:
          (drv.override {srcRepo = true;}).overrideAttrs (old: {
            name = "${name}-${repository.manifest.version}";
            inherit (repository.manifest) version;
            inherit (repository) src;
            postPatch =
              old.postPatch
              + ''
                substituteInPlace lisp/loadup.el \
                --replace '(emacs-repository-get-version)' '"${repository.manifest.rev}"' \
                --replace '(emacs-repository-get-branch)' '"master"'
              '';
          });
      in
        builtins.foldl'
        (drv: fn: fn drv)
        emacs
        ([setSource]
          ++ features
          ++ [forwardPkgs]);

      # Enable nativ comp feature for Emacs.
      enableNativeCompilation = drv:
        drv.overrideAttrs (
          old: {
            patches = [];
            postPatch =
              # XXX: remove when https://github.com/NixOS/nixpkgs/pull/193621 is merged
              lib.optionalString (old ? NATIVE_FULL_AOT)
              (let
                backendPath =
                  lib.concatStringsSep " "
                  (builtins.map (x: ''\"-B${x}\"'') [
                    # Paths necessary so the JIT compiler finds its libraries:
                    "${lib.getLib pkgs.libgccjit}/lib"
                    "${lib.getLib pkgs.libgccjit}/lib/gcc"
                    "${lib.getLib stdenv.cc.libc}/lib"

                    # Executable paths necessary for compilation (ld, as):
                    "${lib.getBin stdenv.cc.cc}/bin"
                    "${lib.getBin stdenv.cc.bintools}/bin"
                    "${lib.getBin stdenv.cc.bintools.bintools}/bin"
                  ]);
              in ''
                substituteInPlace lisp/emacs-lisp/comp.el --replace \
                    "(defcustom comp-libgccjit-reproducer nil" \
                    "(setq native-comp-driver-options '(${backendPath}))
                    (defcustom comp-libgccjit-reproducer nil"
              '');
          }
        );

      # Enable tree-sitter with grammars by modifying the r-path of the
      # Emacs executable.
      #
      # Example: enableTreeSitterWith (p: p; [tree-sitter-c])
      enableTreeSitterWith = pluginsFn: drv:
        (enableTreeSitter drv).overrideAttrs (
          old: let
            plugins = let
              result = pluginsFn pkgs.tree-sitter-grammars;
            in
              if builtins.typeOf result != "list"
              then throw "expected pluginsFn to return a list of grammars, but got ${builtins.typeOf result}"
              else result;
            tree-sitter-grammar-bundle = bundleTreeSitterGrammars plugins;
          in {
            buildInputs = old.buildInputs ++ [tree-sitter-grammar-bundle];
            # Add to list of directories dlopen/dynlib_open searches for tree sitter languages *.so/*.dylib.
            postFixup =
              old.postFixup
              + lib.optionalString stdenv.isDarwin ''
                /usr/bin/install_name_tool -add_rpath ${lib.makeLibraryPath [tree-sitter-grammar-bundle]} $out/bin/emacs
                /usr/bin/codesign -s - -f $out/bin/emacs
              ''
              + lib.optionalString stdenv.isLinux ''
                ${pkgs.patchelf}/bin/patchelf --add-rpath ${lib.makeLibraryPath [tree-sitter-grammar-bundle]} $out/bin/emacs
              '';
          }
        );

      # Enable tree-sitter support without language grammars.
      #
      # Tree-sitter grammars must be provided via
      # `treesit-extra-load-path` inside Emacs. Has the advantage that
      # changing the set of tree-sitter libraries does not trigger a
      # rebuild of Emacs itself (compared to `enableTreeSitterWith`).
      enableTreeSitter = drv:
        drv.overrideAttrs (
          old: {
            buildInputs = old.buildInputs ++ [pkgs.tree-sitter];
            TREE_SITTER_LIBS = "-ltree-sitter";
          }
        );

      # Enable PGTK feature.
      enablePgtk = drv:
        drv.overrideAttrs (
          old: rec {
            configureFlags =
              (lib.remove "--with-xft" old.configureFlags)
              ++ lib.singleton "--with-pgtk";
          }
        );

      # Creates a bundle of tree-sitter grammars which are readable by
      # Emacs.
      bundleTreeSitterGrammars = plugins: let
        libName = drv: lib.removeSuffix "-grammar" drv.pname;
        libSuffix =
          if stdenv.isDarwin
          then "dylib"
          else "so";
        libFileName = drv: ''lib${libName drv}.${libSuffix}'';
        linkCmd = drv:
          if stdenv.isDarwin
          then ''
            cp ${drv}/parser $out/lib/${lib drv}
            # FIXME: Is this kosher?
            /usr/bin/install_name_tool -id $out/lib/${libFileName drv} $out/lib/${libFileName drv}
            /usr/bin/codesign -s - -f $out/lib/${libFileName drv}
          ''
          else ''ln -s ${drv}/parser $out/lib/${libFileName drv}'';
      in
        pkgs.runCommand
        "tree-sitter-grammars"
        {}
        (lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
    };
}
