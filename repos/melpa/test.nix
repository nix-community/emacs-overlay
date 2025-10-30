let

  pkgs = import <nixpkgs> {
    overlays = [
      (import ../../default.nix)
    ];
  };

in {
  inherit (pkgs.emacs.pkgs) melpaStablePackages melpaPackages;
}
