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

  mkEmacsSet = emacs: let
    emacsPackages = lib.recurseIntoAttrs (pkgs.emacsPackagesFor emacs);
    melpaPackages = emacsPackages.melpaPackages;
    isMelpaPackage = n: v: lib.hasAttr n melpaPackages && v == melpaPackages.${n};
    attrs = builtins.removeAttrs emacsPackages dontBuildSubAttrs;
    # Remove melpaPackages from the main set to deduplicate hydra jobs
  in lib.filterAttrs (n: v: ! isMelpaPackage n v) attrs;

in {
  emacsPackages = mkEmacsSet pkgs.emacs;
  emacsUnstablePackages = mkEmacsSet pkgs.emacsUnstable;
}
