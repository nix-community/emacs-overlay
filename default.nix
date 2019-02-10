self: super:
let
  mkExDrv = emacsPackagesNg: name: args: let
    repoMeta = super.lib.importJSON (./. + "/repos/${name}.json");
  in emacsPackagesNg.melpaBuild (args // {
      pname   = name;
      ename   = name;
      version = repoMeta.version;
      recipe  = builtins.toFile "recipe" ''
        (${name} :fetcher github
          :repo "ch11ng/${name}")
      '';

      src = super.fetchFromGitHub {
        owner  = "ch11ng";
        repo   = name;
        inherit (repoMeta) rev sha256;
      };
  });

in {
  emacsPackagesNgFor = emacs:
    (super.emacsPackagesNgFor emacs).overrideScope'(eself: esuper: {
      xelb = mkExDrv eself "xelb" {
        packageRequires = [ eself.cl-generic eself.emacs ];
      };
      exwm = mkExDrv eself "exwm" {
        packageRequires = [ eself.xelb ];
      };
    });
}
