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
# bool to use the value of config or a derivation whose name is default.el
, defaultInitFile ? false
# emulate `use-package-always-ensure` behavior (defaulting to false)
, alwaysEnsure ? false
# emulate `use-package-always-pin` behavior (defaulting to false)
, alwaysPin ? false
# emulate `#+PROPERTY: header-args:emacs-lisp :tangle yes`
, alwaysTangle ? false
, extraEmacsPackages ? epkgs: [ ]
, package ? pkgs.emacs
, override ? (self: super: { })
}:
let
  isOrgModeFile =
    let
      ext = lib.last (builtins.split "\\." (builtins.toString config));
      type = builtins.typeOf config;
    in
      (type == "path" || lib.hasPrefix "/" config) && ext == "org";

  configText =
    let
      type = builtins.typeOf config;
    in # configText can be sourced from either:
      # - A string with context { config = "${hello}/config.el"; }
      if type == "string" && builtins.hasContext config && lib.hasPrefix builtins.storeDir config then builtins.readFile config
      # - A config literal { config = "(use-package foo)"; }
      else if type == "string" then config
      # - A config path { config = ./config.el; }
      else if type == "path" then builtins.readFile config
      # - A derivation { config = pkgs.writeText "config.el" "(use-package foo)"; }
      else if lib.isDerivation config then builtins.readFile "${config}"
      else throw "Unsupported type for config: \"${type}\"";

  packages = parse.parsePackagesFromUsePackage {
    inherit configText isOrgModeFile alwaysTangle alwaysEnsure alwaysPin;
  };
  emacsPackages = (pkgs.emacsPackagesFor package).overrideScope (self: super:
    # for backward compatibility: override was a function with one parameter
    if builtins.isFunction (override super)
    then override self super
    else override super
  );
  emacsWithPackages = emacsPackages.emacsWithPackages;
  mkPackageError = name:
    let
      errorFun = if (alwaysEnsure != null && alwaysEnsure) then builtins.trace else throw;
    in
    errorFun "Emacs package ${name}, declared wanted with use-package, not found." null;
in
emacsWithPackages (epkgs:
  let
    pkgArchives = {
      "gnu" = "elpaPackages";
      "nongnu" = "nongnuPackages";
      "gnu-devel" = "elpaDevelPackages";
      "nongnu-devel" = "nongnuDevelPackages";
      "melpa" = "melpaPackages";
      "melpa-stable" = "melpaStablePackages";
    };
    usePkgs = map (pkg:
      let
        archive = pkgArchives.${pkg.archive};
        name = pkg.name;
      in
      if pkg.archive != null
      then epkgs.${archive}.${name} or (mkPackageError "${archive}.${name}")
      else epkgs.${name} or (mkPackageError name))
      packages;
    extraPkgs = extraEmacsPackages epkgs;
    defaultInitFilePkg =
      if !((builtins.isBool defaultInitFile) || (lib.isDerivation defaultInitFile))
      then throw "defaultInitFile must be bool or derivation"
      else
        if defaultInitFile == false
        then null
        else
          let
            # name of the default init file must be default.el according to elisp manual
            defaultInitFileName = "default.el";
            configFile = pkgs.writeText defaultInitFileName configText;
            orgModeConfigFile = pkgs.runCommand defaultInitFileName {
              nativeBuildInputs = [ package ];
            } ''
              cp ${configFile} config.org
              emacs -Q --batch ./config.org -f org-babel-tangle
              mv config.el $out
            '';
          in
          epkgs.trivialBuild {
            pname = "default";
            src =
              if defaultInitFile == true
              then
                if isOrgModeFile
                then orgModeConfigFile
                else configFile
              else
                if defaultInitFile.name == defaultInitFileName
                then defaultInitFile
                else throw "name of defaultInitFile must be ${defaultInitFileName}";
            version = "0.1.0";
            packageRequires = usePkgs ++ extraPkgs;
          };
  in
  usePkgs ++ extraPkgs ++ [ defaultInitFilePkg ])
