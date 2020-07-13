/*
Parse an emacs package file to derive packages from
Package-Requires declarations.
*/

{ pkgs }:
let
  parse = pkgs.callPackage ./parse.nix { };
in
{ packageElisp
, extraEmacsPackages ? epkgs: [ ]
, package ? pkgs.emacs
, override ? (epkgs: epkgs)
}:
let
  packages = parse.parsePackagesFromPackageRequires packageElisp;
  emacsPackages = pkgs.emacsPackagesGen package;
  emacsWithPackages = emacsPackages.emacsWithPackages;
in
emacsWithPackages (epkgs:
  let
    overriden = override epkgs;
    usePkgs = builtins.map (name: overriden.${name}) packages;
    extraPkgs = extraEmacsPackages overriden;
  in
  [ overriden.use-package ] ++ usePkgs ++ extraPkgs)
