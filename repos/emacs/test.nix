{ pkgs ? import <nixpkgs> { overlays = [ (import ../../default.nix) ]; } }:

let
  package = pkgs.emacsGit;
  emacsPackages = pkgs.emacsPackagesNgGen package;
  emacsWithPackages = emacsPackages.emacsWithPackages;
in emacsWithPackages(epkgs: [ ])
