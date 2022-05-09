{
  description = "Bleeding edge Emacs overlay";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }: {
      # self: super: must be named final: prev: for `nix flake check` to be happy
      overlay = final: prev:
        import ./default.nix final prev;
    } // flake-utils.lib.eachDefaultSystem (system: (
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowAliases = false;
          overlays = [ self.overlay ];
        };
        inherit (pkgs) lib;
        overlayAttrs = builtins.attrNames (import ./. pkgs pkgs);

      in
      {
        packages =
          let
            drvAttrs = builtins.filter (n: lib.isDerivation pkgs.${n}) overlayAttrs;
          in
          lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) drvAttrs);
      }
    ));

}
