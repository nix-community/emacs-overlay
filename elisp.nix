/*
Parse an emacs lisp configuration file to derive packages from
use-package declarations.
*/

{ pkgs }:

let
  parse = pkgs.callPackage ./parse.nix {};
in {
  config,
  extraEmacsPackages ? epkgs: [],
  package ? pkgs.emacs,
  override ? (epkgs: epkgs)
}:
  let
    packages = parse.parsePackagesFromUsePackage config;
    emacsPackages = pkgs.emacsPackagesGen package;
    emacsWithPackages = emacsPackages.emacsWithPackages;
  in
    emacsWithPackages (epkgs:
      let
        overridden = override epkgs;
        usePkgs = builtins.map (name: overridden.${name}) packages;
        extraPkgs = extraEmacsPackages overridden;
      in
        [ overridden.use-package ] ++ usePkgs ++ extraPkgs)
