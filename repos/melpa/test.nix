let

  pkgs = import <nixpkgs> {
    overlays = [
      (import ../../default.nix)
    ];
  };

in {
  inherit (pkgs.emacsPackagesNg) melpaStablePackages melpaPackages;
}
