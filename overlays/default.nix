self: super:
let
  overlays = [
    # package overlay must be applied before emacs overlay
    (import ./repos.nix)
    (import ./package.nix)
    (import ./build.nix)
    (import ./emacs.nix)
  ];
in
super.lib.composeManyExtensions overlays self super
