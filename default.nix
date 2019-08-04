self: super:
let

  mkExDrv = emacsPackagesNg: name: args: let
    repoMeta = super.lib.importJSON (./. + "/repos/${name}.json");
  in emacsPackagesNg.melpaBuild (args // {
    pname   = name;
    ename   = name;
    version = repoMeta.version;
    recipe  = builtins.toFile "recipe" ''
      (${name} :fetcher github
      :repo "ch11ng/${name}")
    '';

    src = super.fetchFromGitHub {
      owner  = "ch11ng";
      repo   = name;
      inherit (repoMeta) rev sha256;
    };
  });

in {

  emacsGit = let
    repoMeta = super.lib.importJSON (./. + "/repos/emacs.json");
  in (super.emacs.override { srcRepo = true; }).overrideAttrs(old: {
    name = "emacs-git-${repoMeta.version}";
    inherit (repoMeta) version;
    src = super.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      inherit (repoMeta) sha256 rev;
    };
    patches = [
      ./patches/tramp-detect-wrapped-gvfsd.patch
      ./patches/clean-env.patch
    ];
  });

  emacsPackagesNgFor = emacs: (
    (super.emacsPackagesNgFor emacs).overrideScope'(eself: esuper: let

      melpaStablePackages = esuper.melpaStablePackages.override {
        archiveJson = ./repos/recipes-archive-melpa.json;
      };

      melpaPackages = esuper.melpaPackages.override {
        archiveJson = ./repos/recipes-archive-melpa.json;
      };

      # TODO: Org/elpa packages

      epkgs = esuper.override {
        inherit melpaStablePackages melpaPackages;
      };

    in epkgs // {
      xelb = mkExDrv eself "xelb" {
        packageRequires = [ eself.cl-generic eself.emacs ];
      };

      exwm = mkExDrv eself "exwm" {
        packageRequires = [ eself.xelb ];
      };
    }));

}
