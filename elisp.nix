/*
Parse an emacs lisp configuration file to derive packages from
use-package (or leaf) declarations.
*/

{ pkgs }:
let
  parse = pkgs.callPackage ./parse.nix { };
  inherit (pkgs) lib;



in
{ config
# emulate `use-package-always-ensure` behavior
# this works as expected with `leaf` as well
, alwaysEnsure ? false
# emulate `#+PROPERTY: header-args:emacs-lisp :tangle yes`
, alwaysTangle ? false
# use `leaf` instead of `use-package`
, useLeaf ? false
, extraEmacsPackages ? epkgs: [ ]
, package ? pkgs.emacs
, override ? (epkgs: epkgs)
}:
let
  managerName =
    if useLeaf then
      "leaf"
    else
      "use-package";

  managerPkg = epkgs:
    if useLeaf then
      epkgs.leaf
    else
      epkgs.use-package;

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
    inherit configText alwaysEnsure isOrgModeFile alwaysTangle useLeaf;
  });
  emacsPackages = pkgs.emacsPackagesGen package;
  emacsWithPackages = emacsPackages.emacsWithPackages;
  mkPackageError = name:
    let
      errorFun = if alwaysEnsure then builtins.trace else throw;
    in
    errorFun "Emacs package ${name}, declared wanted with ${managerName}, not found." null;
in
emacsWithPackages (epkgs:
  let
    overridden = override epkgs;
    usePkgs = map (name: overridden.${name} or (mkPackageError name)) packages;
    extraPkgs = extraEmacsPackages overridden;
  in
  [ (managerPkg overridden) ] ++ usePkgs ++ extraPkgs)
