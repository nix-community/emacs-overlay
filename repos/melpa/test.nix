let

  pkgs = import <nixpkgs> {
    overlays = [
      (import ../../default.nix)
    ];
  };

in {
  inherit (pkgs.emacsPackages) melpaStablePackages melpaPackages;
}
