self: super:
let
  mkSrc = repoName: super.fetchFromGitHub (let
    hashes = super.lib.importJSON (./. + "/repos/${repoName}.json");
  in {
    owner  = "ch11ng";
    repo   = repoName;
    rev    = hashes.rev;
    sha256 = hashes.sha256;
  });

  # TODO: Figure out how to avoid awkward nixpkgs import
  emacsWithPackages = import <nixpkgs/pkgs/build-support/emacs/wrapper.nix> (with super; {
    inherit (xorg) lndir;
    inherit lib makeWrapper stdenv runCommand;
  });

in {
  # emacsPackagesNgFor = emacs: (super.emacsPackagesFor emacs // overridenAttrs);
  emacsPackagesNgFor = emacs: let
    emacsPackagesNg = super.emacsPackagesNgFor emacs;

    overridenAttrs = emacsPackagesNg // (with emacsPackagesNg; let
      xelb = melpaBuild {
        pname   = "xelb";
        ename   = "xelb";
        version = "9999";
        recipe  = builtins.toFile "recipe" ''
          (xelb :fetcher github
                :repo "ch11ng/xelb")
        '';

        packageRequires = [ cl-generic super.emacs ];

        src = mkSrc "xelb";
      };
    in {
      exwm = melpaBuild {
        pname   = "exwm";
        ename   = "exwm";
        version = "9999";
        recipe  = builtins.toFile "recipe" ''
          (exwm :fetcher github
                :repo "ch11ng/exwm")
        '';

        packageRequires = [ xelb ];

        src = mkSrc "exwm";
     };
    });
  in overridenAttrs // {
    emacsWithPackages = emacsWithPackages overridenAttrs;
  };
}
