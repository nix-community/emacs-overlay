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

        (drv: drv.override ({ srcRepo = true; } // args))

        (
          drv: drv.overrideAttrs (
            old: {
              name = "${namePrefix}-${repoMeta.version}";
              inherit (repoMeta) version;
              src = fetcher (builtins.removeAttrs repoMeta [ "type" "version" ]);

              patches = [ ];

              # fixes segfaults that only occur on aarch64-linux (#264)
              configureFlags = old.configureFlags ++
                               super.lib.optionals (super.stdenv.isLinux && super.stdenv.isAarch64)
                                 [ "--enable-check-lisp-object-type" ];

              postPatch = old.postPatch + ''
                substituteInPlace lisp/loadup.el \
                --replace '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
                --replace '(emacs-repository-get-branch)' '"master"'
              '' +
              # XXX: Maybe remove when emacsLsp updates to use Emacs
              # 29.  We already have logic in upstream Nixpkgs to use
              # a different patch for earlier major versions of Emacs,
              # but the major version for emacsLsp follows the format
              # of version YYYYMMDD, as opposed to version (say) 29.
              # Removing this here would also require that we don't
              # overwrite the patches attribute in the overlay to an
              # empty list since we would then expect the Nixpkgs
              # patch to be used. Not sure if it's better to rely on
              # upstream Nixpkgs since it's cumbersome to wait for
              # things to get merged into master.
                (super.lib.optionalString (old ? NATIVE_FULL_AOT)
                    (let backendPath = (super.lib.concatStringsSep " "
                      (builtins.map (x: ''\"-B${x}\"'') ([
                        # Paths necessary so the JIT compiler finds its libraries:
                        "${super.lib.getLib self.libgccjit}/lib"
                        "${super.lib.getLib self.libgccjit}/lib/gcc"
                        "${super.lib.getLib self.stdenv.cc.libc}/lib"
		      ] ++ super.lib.optionals (self.stdenv.cc?cc.libgcc) [
			"${super.lib.getLib self.stdenv.cc.cc.libgcc}/lib"
		      ] ++ [

                        # Executable paths necessary for compilation (ld, as):
                        "${super.lib.getBin self.stdenv.cc.cc}/bin"
                        "${super.lib.getBin self.stdenv.cc.bintools}/bin"
                        "${super.lib.getBin self.stdenv.cc.bintools.bintools}/bin"
                      ])));
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
      ]);

  emacsGit = (super.lib.makeOverridable (mkGitEmacs "emacs-git" ../repos/emacs/emacs-master.json) { withSQLite3 = true; withWebP = true; withTreeSitter = true; }).overrideAttrs (
    oa: {
      patches = oa.patches ++ [
        # XXX: #318
        ./bytecomp-revert.patch
      ]; }
  );

  emacsPgtk = (super.lib.makeOverridable (mkGitEmacs "emacs-pgtk" ../repos/emacs/emacs-master.json) { withSQLite3 = true; withWebP = true; withTreeSitter = true; withPgtk = true; }).overrideAttrs (
    oa: {
      patches = oa.patches ++ [
        # XXX: #318
        ./bytecomp-revert.patch
      ]; }
  );

  emacsUnstable = super.lib.makeOverridable (mkGitEmacs "emacs-unstable" ../repos/emacs/emacs-unstable.json) { withSQLite3 = true; withWebP = true; withTreeSitter = true; };

  emacsUnstablePgtk = super.lib.makeOverridable (mkGitEmacs "emacs-unstable" ../repos/emacs/emacs-unstable.json) { withSQLite3 = true; withWebP = true; withTreeSitter = true; withPgtk = true; };

  emacsLsp = (mkGitEmacs "emacs-lsp" ../repos/emacs/emacs-lsp.json { withTreeSitter = false; });

in
{
  inherit emacsGit emacsUnstable;

  inherit emacsPgtk emacsUnstablePgtk;

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
