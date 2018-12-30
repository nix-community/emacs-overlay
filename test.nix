with import <nixpkgs> {
  overlays = [ (import ./default.nix) ];
};
emacsWithPackages(epkgs: [
  epkgs.exwm
])
