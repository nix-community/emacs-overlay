self: super:
let
  mkExDrv = emacsPackages: name: args:
    let
      repoMeta = super.lib.importJSON (./repos/exwm/. + "/${name}.json");
    in
    emacsPackages.melpaBuild (
      args // {
        pname = name;
        ename = name;
        version = repoMeta.version;
        commit = repoMeta.rev;

        recipe = builtins.toFile "recipe" ''
          (${name} :fetcher github
          :repo "ch11ng/${name}")
        '';

        src = super.fetchFromGitHub {
          owner = "ch11ng";
          repo = name;
          inherit (repoMeta) rev sha256;
        };
      }
    );

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
      [

        (drv: drv.override ({ srcRepo = true; withSQLite3 = true; withWebP = true; } // args))

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
      ];

  emacsGit = mkGitEmacs "emacs-git" ./repos/emacs/emacs-master.json { };

  emacsNativeComp = super.emacsNativeComp or (mkGitEmacs "emacs-native-comp" ./repos/emacs/emacs-unstable.json { nativeComp = true; });

  emacsGitNativeComp = mkGitEmacs "emacs-git-native-comp" ./repos/emacs/emacs-master.json {
    nativeComp = true;
  };

  emacsPgtk = mkGitEmacs "emacs-pgtk" ./repos/emacs/emacs-master.json { withPgtk = true; };

  emacsPgtkNativeComp = mkGitEmacs "emacs-pgtk-native-comp" ./repos/emacs/emacs-master.json { nativeComp = true; withPgtk = true; };

  emacsUnstable = (mkGitEmacs "emacs-unstable" ./repos/emacs/emacs-unstable.json { });

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

  emacsWithPackagesFromUsePackage = import ./elisp.nix { pkgs = self; };

  emacsWithPackagesFromPackageRequires = import ./packreq.nix { pkgs = self; };

  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope' (
      eself: esuper:
        let
          melpaStablePackages = esuper.melpaStablePackages.override {
            archiveJson = ./repos/melpa/recipes-archive-melpa.json;
          };

          melpaPackages = esuper.melpaPackages.override {
            archiveJson = ./repos/melpa/recipes-archive-melpa.json;
          };

          elpaPackages = esuper.elpaPackages.override {
            generated = ./repos/elpa/elpa-generated.nix;
          };

          epkgs = esuper.override {
            inherit melpaStablePackages melpaPackages elpaPackages;
          };

        in
        epkgs
        // super.lib.optionalAttrs (super.lib.hasAttr "nongnuPackages" esuper) {
          nongnuPackages = esuper.nongnuPackages.override {
            generated = ./repos/nongnu/nongnu-generated.nix;
          };
        } // {
          xelb = mkExDrv eself "xelb" {
            packageRequires = [ eself.cl-generic eself.emacs ];
          };

          exwm = mkExDrv eself "exwm" {
            packageRequires = [ eself.xelb ];
          };
        }
    )
  );

} // super.lib.optionalAttrs (super.config.allowAliases or true) {
  emacsGcc = builtins.trace "emacsGcc has been renamed to emacsNativeComp, please update your expression." emacsNativeComp;
  emacsPgtkGcc = builtins.trace "emacsPgtkGcc has been renamed to emacsPgtkNativeComp, please update your expression." emacsPgtkNativeComp;
}
