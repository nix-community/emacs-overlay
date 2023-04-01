{
  description = "Bleeding edge Emacs overlay";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }: {
      # self: super: must be named final: prev: for `nix flake check` to be happy
      overlays = {
        default = final: prev: import ./overlays final prev;
        emacs = final: prev: import ./overlays/emacs.nix final prev;
        package = final: prev: import ./overlays/package.nix final prev;
      };
      # for backward compatibility, is safe to delete, not referenced anywhere
      overlay = self.overlays.default;
    } // flake-utils.lib.eachDefaultSystem (system: (
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowAliases = false;
          overlays = [ self.overlays.default ];
        };
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
