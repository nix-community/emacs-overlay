/*
Parse an emacs lisp configuration file to derive packages from
use-package declarations.
*/

{ pkgs }:

let
  parse = pkgs.callPackage ./parse.nix {};
in {
  config,
  alwaysEnsure ? false, # emulate `use-package-always-ensure` behavior
  extraEmacsPackages ? epkgs: [],
  package ? pkgs.emacs,
  override ? (epkgs: epkgs)
}:
  let
    packages = parse.parsePackagesFromUsePackage config alwaysEnsure;
    emacsPackages = pkgs.emacsPackagesGen package;
    emacsWithPackages = emacsPackages.emacsWithPackages;
    mkPackageError = name:
      let
        errorFun = if alwaysEnsure then builtins.trace else throw;
      in
        errorFun "Emacs package ${name}, declared wanted with use-package, not found." null;
  in
    emacsWithPackages (epkgs:
      let
        overridden = override epkgs;
        usePkgs = map (name: overridden.${name} or (mkPackageError name)) packages;
        extraPkgs = extraEmacsPackages overridden;
      in
        [ overridden.use-package ] ++ usePkgs ++ extraPkgs)
