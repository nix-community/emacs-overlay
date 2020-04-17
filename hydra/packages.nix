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
  in builtins.removeAttrs emacsPackages dontBuildSubAttrs;

in {
  emacsPackages = mkEmacsSet pkgs.emacs;
  emacsUnstablePackages = mkEmacsSet pkgs.emacsUnstable;
}
