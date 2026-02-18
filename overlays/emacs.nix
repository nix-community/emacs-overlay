self: super:
let
  mkGitEmacs = namePrefix: jsonFile: { ... }@args:
    let
      repoMeta = super.lib.importJSON jsonFile;
      fetcher =
        if repoMeta.type == "savannah" then
          super.fetchgit
        else if repoMeta.type == "github" then
          super.fetchFromGitHub
        else
          throw "Unknown repository type ${repoMeta.type}!";
    in
    builtins.foldl'
      (drv: fn: fn drv)
      super.emacs
      ([

        (drv: drv.override ({ srcRepo = true; withXwidgets = false; } // args))

        (
          drv: drv.overrideAttrs (
            old: {
              name = "${namePrefix}-${repoMeta.version}";
              inherit (repoMeta) version;
              src = fetcher (builtins.removeAttrs repoMeta [ "type" "version" ]);

              # fixes segfaults that only occur on aarch64-linux (#264)
              configureFlags = old.configureFlags ++
                               super.lib.optionals (super.stdenv.isLinux && super.stdenv.isAarch64)
                                 [ "--enable-check-lisp-object-type" ];

              postPatch = old.postPatch + ''
                substituteInPlace lisp/loadup.el \
                --replace-warn '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
                --replace-warn '(emacs-repository-get-branch)' '"master"'
              '';
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

  emacs-git = let base = (mkGitEmacs "emacs-git" ../repos/emacs/emacs-master.json) { };
                  emacs = emacs-git;
              in
                base.overrideAttrs (
                  oa: {
                    passthru = oa.passthru // {
                        pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                    };
                  });

  emacs-git-pgtk = let base = (mkGitEmacs "emacs-git-pgtk" ../repos/emacs/emacs-master.json) { withPgtk = true; };
                   emacs = emacs-git-pgtk;
               in base.overrideAttrs (
                 oa: {
                    passthru = oa.passthru // {
                        pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                    };
                 });

  emacs-unstable = let base = (mkGitEmacs "emacs-unstable" ../repos/emacs/emacs-unstable.json) { };
                       emacs = emacs-unstable;
                   in
                     base.overrideAttrs (
                       oa: {
                         passthru = oa.passthru // {
                           pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                         };
                       });

  emacs-unstable-pgtk = let base = (mkGitEmacs "emacs-unstable-pgtk" ../repos/emacs/emacs-unstable.json) { withPgtk = true; };
                            emacs = emacs-unstable-pgtk;
                        in
                          base.overrideAttrs (
                            oa: {
                              passthru = oa.passthru // {
                                pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                              };
                            });

  emacs-igc = let base = (mkGitEmacs "emacs-igc" ../repos/emacs/emacs-feature_igc.json) { };
                  emacs = emacs-igc;
              in
                base.overrideAttrs (
                  oa: {
                    buildInputs = oa.buildInputs ++ [ super.mps ];
                    configureFlags = oa.configureFlags ++ [ "--with-mps=yes" ];
                    passthru = oa.passthru // {
                      pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                    };
                  });

  emacs-igc-pgtk = let base = (mkGitEmacs "emacs-igc-pgtk" ../repos/emacs/emacs-feature_igc.json) { withPgtk = true; };
                       emacs = emacs-igc-pgtk;
                   in
                     base.overrideAttrs (
                       oa: {
                         buildInputs = oa.buildInputs ++ [ super.mps ];
                         configureFlags = oa.configureFlags ++ [ "--with-mps=yes" ];
                         passthru = oa.passthru // {
                           pkgs = oa.passthru.pkgs.overrideScope (eself: esuper: { inherit emacs; });
                         };
                       });

  emacs-lsp = (mkGitEmacs "emacs-lsp" ../repos/emacs/emacs-lsp.json) { withTreeSitter = false; };

  commercial-emacs = (mkGitEmacs "commercial-emacs" ../repos/emacs/commercial-emacs-commercial-emacs.json) {
    withTreeSitter = false;
    withNativeCompilation = false;
  };

  emacs-git-nox = (
    (
      emacs-git.override {
        withNS = false;
        withX = false;
        withGTK3 = false;
        withWebP = false;
      }
    ).overrideAttrs (
      oa: {
        name = "${oa.name}-nox";
      }
    )
  );

  emacs-unstable-nox = (
    (
      emacs-unstable.override {
        withNS = false;
        withX = false;
        withGTK3 = false;
        withWebP = false;
      }
    ).overrideAttrs (
      oa: {
        name = "${oa.name}-nox";
      }
    )
  );

in
{
  inherit emacs-git emacs-unstable;

  inherit emacs-git-pgtk emacs-unstable-pgtk;

  inherit emacs-git-nox emacs-unstable-nox;

  inherit emacs-lsp;

  inherit commercial-emacs;

  inherit emacs-igc emacs-igc-pgtk;

  emacsWithPackagesFromUsePackage = import ../elisp.nix { pkgs = self; };

  emacsWithPackagesFromPackageRequires = import ../packreq.nix { pkgs = self; };

} // super.lib.optionalAttrs (super.config.allowAliases or true) {
  emacsGcc = builtins.trace "emacsGcc has been renamed to emacs-git, please update your expression." emacs-git;
  emacsGitNativeComp = builtins.trace "emacsGitNativeComp has been renamed to emacs-git, please update your expression." emacs-git;
  emacsGitTreeSitter = builtins.trace "emacsGitTreeSitter has been renamed to emacs-git, please update your expression." emacs-git;
  emacsNativeComp = builtins.trace "emacsNativeComp has been renamed to emacs-unstable, please update your expression." emacs-unstable;
  emacsPgtkGcc = builtins.trace "emacsPgtkGcc has been renamed to emacs-pgtk, please update your expression." self.emacs-pgtk;
  emacsPgtkNativeComp = builtins.trace "emacsPgtkNativeComp has been renamed to emacs-pgtk, please update your expression." self.emacs-pgtk;

  emacsGit = builtins.trace "emacsGit has been renamed to emacs-git, please update your expression." emacs-git;
  emacsUnstable = builtins.trace "emacsUnstable has been renamed to emacs-unstable, please update your expression." emacs-unstable;
  emacsPgtk = builtins.trace "emacsPgtk has been renamed to emacs-pgtk, please update your expression." self.emacs-pgtk;
  emacsUnstablePgtk = builtins.trace "emacsUnstablePgtk has been renamed to emacs-unstable-pgtk, please update your expression." emacs-unstable-pgtk;
  emacsGitNox = builtins.trace "emacsGitNox has been renamed to emacs-git-nox, please update your expression." emacs-git-nox;
  emacsUnstableNox = builtins.trace "emacsUnstableNox has been renamed to emacs-unstable-nox, please update your expression." emacs-unstable-nox;
  emacsLsp = throw "emacsLsp has been removed, please update your expression.";
}
