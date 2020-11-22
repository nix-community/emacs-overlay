{ nixpkgs }:
let
  pkgs = import ./pkgs.nix nixpkgs;
in pkgs.mkEmacsSet pkgs.emacsPgtk
