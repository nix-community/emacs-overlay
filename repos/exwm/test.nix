{ pkgs ? import <nixpkgs> { overlays = [ (import ../../default.nix) ]; } }:

let
  package = pkgs.emacs;
  emacsPackages = pkgs.emacsPackagesNgGen package;
  emacsWithPackages = emacsPackages.emacsWithPackages;
in emacsWithPackages(epkgs: [
  epkgs.exwm
])
