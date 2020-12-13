/*
Parse an emacs lisp configuration file to derive packages from
use-package declarations.
*/

{ pkgs }:
let
  parse = pkgs.callPackage ./parse.nix { };
  inherit (pkgs) lib;



in
{ config
# emulate `use-package-always-ensure` behavior
, alwaysEnsure ? false
# emulate `#+PROPERTY: header-args:emacs-lisp :tangle yes`
, alwaysTangle ? false
, extraEmacsPackages ? epkgs: [ ]
, package ? pkgs.emacs
, override ? (epkgs: epkgs)
}:
let
  ensureNotice = ''
    Emacs-overlay API breakage notice:

    Previously emacsWithPackagesFromUsePackage always added every use-package definition to the closure.
    Now we will only add packages with `:ensure`, `:ensure t` or `:ensure <package name>`.

    You can get back the old behaviour by passing `alwaysEnsure = true`.
    For a more in-depth usage example see https://github.com/nix-community/emacs-overlay#extra-library-functionality
  '';
  showNotice = value: if alwaysEnsure then value else builtins.trace ensureNotice value;

  isOrgModeFile =
    let
      ext = lib.last (builtins.split "\\." (builtins.toString config));
      type = builtins.typeOf config;
    in
      type == "path" && ext == "org";

  configText =
    let
      type = builtins.typeOf config;
    in
      if type == "string" then config
      else if type == "path" then builtins.readFile config
      else throw "Unsupported type for config: \"${type}\"";

  packages = showNotice (parse.parsePackagesFromUsePackage {
    inherit configText alwaysEnsure isOrgModeFile alwaysTangle;
  });
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
  usePkgs ++ extraPkgs)
