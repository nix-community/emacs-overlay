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
, override ? (self: super: { })
}:
let
  packages = parse.parsePackagesFromPackageRequires packageElisp;
  emacsPackages = (pkgs.emacsPackagesFor package).overrideScope' (self: super:
    # for backward compatibility: override was a function with one parameter
    if builtins.isFunction (override super)
    then override self super
    else override super
  );
  emacsWithPackages = emacsPackages.emacsWithPackages;
in
emacsWithPackages (epkgs:
  let
    usePkgs = builtins.map (name: epkgs.${name}) packages;
    extraPkgs = extraEmacsPackages epkgs;
  in
  [ epkgs.use-package ] ++ usePkgs ++ extraPkgs)
