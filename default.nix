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
      self.emacs
      [

        (drv: drv.override ({ srcRepo = true; } // args))

        (
          drv: drv.overrideAttrs (
            old: {
              name = "${namePrefix}-${repoMeta.version}";
              inherit (repoMeta) version;
              src = fetcher (builtins.removeAttrs repoMeta [ "type" "version" ]);

              patches = [
                ./patches/tramp-detect-wrapped-gvfsd.patch
              ];
              postPatch = old.postPatch + ''
                substituteInPlace lisp/loadup.el \
                --replace '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
                --replace '(emacs-repository-get-branch)' '"master"'
              '';

            }
          )
        )

        # --with-nativecomp was changed to --with-native-compilation
        # Remove this once 21.05 is released
        (drv: if drv.passthru.nativeComp && self.lib.elem "--with-nativecomp" drv.configureFlags then drv.overrideAttrs(old: {
          configureFlags = builtins.map (flag: if flag == "--with-nativecomp" then "--with-native-compilation" else flag) old.configureFlags;
        }) else drv)

        # reconnect pkgs to the built emacs
        (
          drv: let
            result = drv.overrideAttrs (old: {
              passthru = old.passthru // {
                pkgs = self.emacsPackagesFor result;
              };
            });
          in result
        )
      ];

  mkPgtkEmacs = namePrefix: jsonFile: { ... }@args: (mkGitEmacs namePrefix jsonFile args).overrideAttrs (
    old: {
      configureFlags = (super.lib.remove "--with-xft" old.configureFlags)
        ++ super.lib.singleton "--with-pgtk";
    }
  );

  emacsGit = mkGitEmacs "emacs-git" ./repos/emacs/emacs-master.json { };

  emacsGcc = (mkGitEmacs "emacs-gcc" ./repos/emacs/emacs-feature_native-comp.json { nativeComp = true; });

  emacsPgtk = mkPgtkEmacs "emacs-pgtk" ./repos/emacs/emacs-feature_pgtk.json { };

  emacsPgtkGcc = (mkPgtkEmacs "emacs-pgtkgcc" ./repos/emacs/emacs-pgtk-nativecomp.json { nativeComp = true; });

  emacsUnstable = (mkGitEmacs "emacs-unstable" ./repos/emacs/emacs-unstable.json { }).overrideAttrs (
    old: {
      patches = [
        ./patches/tramp-detect-wrapped-gvfsd-27.patch
      ];
    }
  );

in
{
  inherit emacsGit emacsUnstable;

  inherit emacsGcc;

  inherit emacsPgtk emacsPgtkGcc;

  emacsGit-nox = (
    (
      emacsGit.override {
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
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
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
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

          orgPackages = esuper.orgPackages.override {
            generated = ./repos/org/org-generated.nix;
          };

          epkgs = esuper.override {
            inherit melpaStablePackages melpaPackages elpaPackages orgPackages;
          };

        in
        epkgs // {
          xelb = mkExDrv eself "xelb" {
            packageRequires = [ eself.cl-generic eself.emacs ];
          };

          exwm = mkExDrv eself "exwm" {
            packageRequires = [ eself.xelb ];
          };
        }
    )
  );

}
