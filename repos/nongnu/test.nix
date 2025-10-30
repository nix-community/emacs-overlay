let

  pkgs = import <nixpkgs> {
    overlays = [
      (import ../../default.nix)
    ];
  };

in pkgs.emacs.pkgs
