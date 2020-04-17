{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };
  inherit (pkgs) lib;

  mkEmacsSet = emacs: lib.recurseIntoAttrs (pkgs.emacsPackagesFor emacs);

in {
  # emacsPackages = mkEmacsSet pkgs.emacs;
  # emacsUnstablePackages = mkEmacsSet pkgs.emacsUnstable;
  inherit (pkgs) emacsUnstable emacsUnstable-nox;
  # inherit (pkgs) emacsGit emacsGit-nox;
  # Note that we're not building packages for emacsGit
}
