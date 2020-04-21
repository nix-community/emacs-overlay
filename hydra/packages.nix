{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };
  inherit (pkgs) lib;

  # Save a lot of building by omiting some subsets
  dontBuildSubAttrs = [
    "melpaStablePackages"
  ];

  isValid = d: let
    r = builtins.tryEval (lib.isDerivation d && builtins.seq d.name (! (lib.attrByPath [ "meta" "broken" ] false d)) && "${d}" != "");
  in r.success && r.value;

  mkEmacsSet = emacs: let
    emacsPackages = lib.recurseIntoAttrs (pkgs.emacsPackagesFor emacs);
    melpaPackages = emacsPackages.melpaPackages;
    # Dont iterate over melpa stable
    attrs = builtins.removeAttrs emacsPackages dontBuildSubAttrs;
    # Remove melpaPackages from the main set to deduplicate hydra jobs
    isMelpaPackage = n: v: lib.hasAttr n melpaPackages && isValid v && isValid melpaPackages.${n} && v == melpaPackages.${n};
  in lib.filterAttrs (n: v: ! isMelpaPackage n v) attrs;

in {
  emacsPackages = mkEmacsSet pkgs.emacs;
  emacsUnstablePackages = mkEmacsSet pkgs.emacsUnstable;
}
