{ pkgs, lib ? pkgs.lib }:

{

  mkEmacsSet = emacs: let
    emacsPackages = pkgs.recurseIntoAttrs (pkgs.emacsPackagesFor emacs);
  in {
    inherit (emacsPackages) elpaPackages;
    inherit (emacsPackages) melpaStablePackages;
    inherit (emacsPackages) melpaPackages;
    inherit (emacsPackages) orgPackages;
    # Has broken meta
    manualPackages = builtins.removeAttrs emacsPackages.manualPackages [
      "emacspeak"
    ];
  };


}
