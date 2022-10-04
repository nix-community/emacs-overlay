self: super:
let
  inherit (super.lib) foldl' flip extends;
  overlays = [
    # package overlay must be applied before emacs overlay
    (import ./package.nix)
    (import ./emacs.nix)
  ];
in
foldl' (flip extends) (_: super) overlays self
