nixpkgs:

import nixpkgs {
  overlays = [
    (import ../default.nix)
    (self: super: {
      mkEmacsSet = emacs: { emacsPackages = super.recurseIntoAttrs (self.emacsPackagesFor emacs); };
    })
  ];
}
