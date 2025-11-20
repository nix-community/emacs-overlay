self: super:
{
  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope (
      eself: esuper:
        let
          melpaStablePackages = esuper.melpaStablePackages.override {
            archiveJson = ../repos/melpa/recipes-archive-melpa.json;
          };

          melpaPackages = esuper.melpaPackages.override {
            archiveJson = ../repos/melpa/recipes-archive-melpa.json;
          };

          elpaDevelPackages = esuper.elpaDevelPackages.override {
            generated = ../repos/elpa/elpa-devel-generated.nix;
          };

          elpaPackages = (esuper.elpaPackages.override {
            generated = ../repos/elpa/elpa-generated.nix;
          }) // {
            # Tramp 2.8.0.4 has a broken tarball
            tramp =
              if esuper.elpaPackages.tramp.version != "2.8.0.4" then esuper.elpaPackages.tramp
              else esuper.elpaPackages.tramp.overrideAttrs {
                version = "2.8.0.3";
                src = self.fetchurl {
                  name = "tramp-2.8.0.3.tar";
                  url = "https://elpa.gnu.org/packages/tramp-2.8.0.3.tar.lz";
                  downloadToTemp = true;
                  postFetch = ''
                    cp $downloadedFile tramp-2.8.0.3.tar.lz
                    ${self.lib.getExe self.lzip} -d tramp-2.8.0.3.tar.lz
                    mv tramp-2.8.0.3.tar $out
                  '';
                  hash = "sha256-o+heQw47btZhhM+5GtvzUZlqcNaoW3966fZyj8m6X+M=";
                };
              };
          };

          nongnuDevelPackages = esuper.nongnuDevelPackages.override {
            generated = ../repos/nongnu/nongnu-devel-generated.nix;
          };

          nongnuPackages = esuper.nongnuPackages.override {
            generated = ../repos/nongnu/nongnu-generated.nix;
          };

        in
          esuper.override {
            inherit melpaStablePackages melpaPackages elpaDevelPackages elpaPackages
              nongnuDevelPackages nongnuPackages;
          }

    )
  );

}
