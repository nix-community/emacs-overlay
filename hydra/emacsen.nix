{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };

in {
  inherit (pkgs) emacsUnstable emacsUnstable-nox;
  inherit (pkgs) emacsGit emacsGit-nox;
}
