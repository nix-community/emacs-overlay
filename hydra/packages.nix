{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };
  inherit (pkgs) lib;

  mkEmacsSet = emacs: let
    emacsPackages = lib.recurseIntoAttrs (pkgs.emacsPackagesFor emacs);
  in {
    inherit (emacsPackages) elpaPackages;
    inherit (emacsPackages) melpaStablePackages;
    inherit (emacsPackages) melpaPackages;
    inherit (emacsPackages) orgPackages;
    # Has broken meta
    manualPackages = builtins.removeAttrs emacsPackages.manualPackages [
      "emacspeak"
    ];
  };

in {
  emacsPackages = mkEmacsSet pkgs.emacs;
  emacsUnstablePackages = mkEmacsSet pkgs.emacsUnstable;
}
