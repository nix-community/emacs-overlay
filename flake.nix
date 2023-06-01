{
  description = "Bleeding edge Emacs overlay";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , flake-utils
    }:
    let
      importPkgs = path: attrs: import path (attrs // {
        config.allowAliases = false;
        overlays = [ self.overlays.default ];
      });
    in
    {
      # self: super: must be named final: prev: for `nix flake check` to be happy
      overlays = {
        default = final: prev: import ./overlays final prev;
        emacs = final: prev: import ./overlays/emacs.nix final prev;
        package = final: prev: import ./overlays/package.nix final prev;
      };
      # for backward compatibility, is safe to delete, not referenced anywhere
      overlay = self.overlays.default;
    } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    {
      hydraJobs =
        let
          mkHydraJobs = pkgs:
            let
              mkEmacsSet = emacs: pkgs.recurseIntoAttrs (
                pkgs.lib.filterAttrs
                  (n: v: builtins.typeOf v == "set" && ! pkgs.lib.isDerivation v)
                  (pkgs.emacsPackagesFor emacs)
              );

            in
            {
              emacsen = {
                inherit (pkgs) emacs-unstable emacs-unstable-nox;
                inherit (pkgs) emacs-git emacs-git-nox;
                inherit (pkgs) emacs-pgtk;
              };

              emacsen-cross =
                let
                  crossTargets = [ "aarch64-multiplatform" ];
                in
                lib.fold lib.recursiveUpdate { }
                  (builtins.map
                    (target:
                      let
                        targetPkgs = pkgs.pkgsCross.${target};
                      in
                      lib.mapAttrs' (name: job: lib.nameValuePair "${name}-${target}" job)
                        ({
                          inherit (targetPkgs) emacs-unstable emacs-unstable-nox;
                          inherit (targetPkgs) emacs-git emacs-git-nox;
                          inherit (targetPkgs) emacs-pgtk;
                        }))
                    crossTargets);

              packages = mkEmacsSet pkgs.emacs;
              packages-unstable = mkEmacsSet pkgs.emacs-unstable;
            };

        in
        {
          "22.11" = mkHydraJobs (importPkgs nixpkgs-stable { inherit system; });
          "unstable" = mkHydraJobs (importPkgs nixpkgs { inherit system; };);
        };
    }) // flake-utils.lib.eachDefaultSystem (system: (
      let
        pkgs = importPkgs nixpkgs { inherit system; };
        inherit (pkgs) lib;

        overlayAttributes = lib.pipe (import ./. pkgs pkgs) [
          builtins.attrNames
          (lib.partition (n: lib.isDerivation pkgs.${n}))
        ];
        attributesToAttrset = attributes: lib.pipe attributes [
          (map (n: lib.nameValuePair n pkgs.${n}))
          lib.listToAttrs
        ];

      in
      {
        lib = attributesToAttrset overlayAttributes.wrong;
        packages = attributesToAttrset overlayAttributes.right;
      }
    ));

}
