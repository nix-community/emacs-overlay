self: super:
let
  # TODO: Figure out how to avoid awkward nixpkgs import
  emacsWithPackages = import <nixpkgs/pkgs/build-support/emacs/wrapper.nix> (with super; {
    inherit (xorg) lndir;
    inherit lib makeWrapper stdenv runCommand;
  });

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
  emacsPackagesNgFor = emacs: let
    emacsPackagesNg = super.emacsPackagesNgFor emacs;

    overridenAttrs = emacsPackagesNg // (with emacsPackagesNg; let
      xelb = mkExDrv emacsPackagesNg "xelb" {
        packageRequires = [ cl-generic emacs ];
      };
      exwm = mkExDrv emacsPackagesNg "exwm" {
        packageRequires = [ xelb ];
      };
    in {
      inherit exwm xelb;
    });
  in overridenAttrs // {
    emacsWithPackages = emacsWithPackages overridenAttrs;
  };
}
