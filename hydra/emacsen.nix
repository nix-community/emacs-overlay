{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };
  inherit (pkgs) lib;

in {
  inherit (pkgs) emacsUnstable emacsUnstable-nox;
  inherit (pkgs) emacsGit emacsGit-nox;
  inherit (pkgs) emacsPgtk;
} // lib.optionalAttrs (lib.hasAttr "libgccjit" pkgs) {
  inherit (pkgs) emacsGcc emacsPgtkGcc;
}
