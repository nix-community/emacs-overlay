{ nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };

  inherit (import ./lib.nix { inherit pkgs; }) mkEmacsSet;

in {
  emacsGccPackages = mkEmacsSet pkgs.emacsGcc;
}
