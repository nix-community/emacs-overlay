nixpkgs:

import nixpkgs {
  overlays = [
    (import ../default.nix)
    (self: super: let
      inherit (self) lib;
    in {
      # Build package sets and remove merged root-level packages since they are
      # both present in each respective sub set and in the top-level
      mkEmacsSet = emacs: super.recurseIntoAttrs (
        lib.filterAttrs
        (n: v: builtins.typeOf v == "set" && ! lib.isDerivation v)
        (self.emacsPackagesFor emacs)
      );
    })
  ];
}
