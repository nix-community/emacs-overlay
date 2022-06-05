{ nixpkgs }:
let
  crossTargets = [ "aarch64-multiplatform" ];
  pkgs = import nixpkgs {
    overlays = [
      (import ../default.nix)
    ];
  };
  inherit (pkgs) lib;
in
lib.fold lib.recursiveUpdate { }
  (builtins.map
    (target:
      let
        targetPkgs = pkgs.pkgsCross.${target};
      in
      lib.mapAttrs' (name: job: lib.nameValuePair "${name}-${target}" job)
        ({
          inherit (targetPkgs) emacsUnstable emacsUnstable-nox;
          inherit (targetPkgs) emacsGit emacsGit-nox;
          inherit (targetPkgs) emacsPgtk;
        } // lib.optionalAttrs (lib.hasAttr "libgccjit" targetPkgs) {
          inherit (targetPkgs) emacsNativeComp emacsGitNativeComp emacsPgtkNativeComp;
        }))
    crossTargets)
