self: super:
let

  mkExDrv = emacsPackages: name: args: let
    repoMeta = super.lib.importJSON (./repos/exwm/. + "/${name}.json");
  in emacsPackages.melpaBuild (args // {
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

  mkGitEmacs = namePrefix: jsonFile:
    (self.emacs.override { srcRepo = true; }).overrideAttrs(old: (let
      repoMeta = super.lib.importJSON jsonFile;
      attrs = {
        name = "${namePrefix}-${repoMeta.version}";
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
        postPatch = old.postPatch + ''
          substituteInPlace lisp/loadup.el \
          --replace '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
          --replace '(emacs-repository-get-branch)' '"master"'
        '';
      };
    in attrs));

  emacsGit = mkGitEmacs "emacs-git" ./repos/emacs/emacs-master.json;

  emacsGcc = (mkGitEmacs "emacs-gcc" ./repos/emacs/emacs-feature_native-comp.json).override {
    nativeComp = true;
  };

  emacsUnstable = let
    repoMeta = super.lib.importJSON ./repos/emacs/emacs-unstable.json;
  in (self.emacs.override { srcRepo = true; }).overrideAttrs(old: {
    name = repoMeta.version;
    inherit (repoMeta) version;
    src = super.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      inherit (repoMeta) sha256 rev;
    };
    patches = [
      ./patches/tramp-detect-wrapped-gvfsd-27.patch
      ./patches/clean-env.patch
    ];
  });

in {
  inherit emacsGit emacsUnstable;

  inherit emacsGcc;

  emacsGit-nox = ((emacsGit.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }).overrideAttrs(oa: {
    name = "${oa.name}-nox";
  }));

  emacsUnstable-nox = ((emacsUnstable.override {
    withX = false;
    withGTK2 = false;
    withGTK3 = false;
  }).overrideAttrs(oa: {
    name = "${oa.name}-nox";
  }));

  emacsWithPackagesFromUsePackage = import ./elisp.nix { pkgs = self; };

  emacsWithPackagesFromPackageRequires = import ./packreq.nix { pkgs = self; };

  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope'(eself: esuper: let

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

    in epkgs // {
      xelb = mkExDrv eself "xelb" {
        packageRequires = [ eself.cl-generic eself.emacs ];
      };

      exwm = mkExDrv eself "exwm" {
        packageRequires = [ eself.xelb ];
      };
    }));

}
