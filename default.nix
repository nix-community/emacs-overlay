self: super:
let
  mkSrc = repoName: super.fetchFromGitHub (let
    hashes = super.lib.importJSON (./. + "/repos/${repoName}.json");
  in {
    owner  = "ch11ng";
    repo   = repoName;
    rev    = hashes.rev;
    sha256 = hashes.sha256;
  });


in {
  # emacsPackagesNgFor = emacs: (super.emacsPackagesFor emacs // overridenAttrs);
  emacsPackagesNgFor = emacs: let
    emacsPackagesNg = super.emacsPackagesNgFor emacs;
    overridenAttrs = (with emacsPackagesNg; let
      xelb = melpaBuild {
        pname   = "xelb";
        ename   = "xelb";
        version = "0.15";
        recipe  = builtins.toFile "recipe" ''
          (xelb :fetcher github
                :repo "ch11ng/xelb")
        '';

        packageRequires = [ cl-generic super.emacs ];

        src = mkSrc "xelb";
      };
    in {
      exwm = melpaBuild {
        pname   = "exwm";
        ename   = "exwm";
        version = "0.19";
        recipe  = builtins.toFile "recipe" ''
          (exwm :fetcher github
                :repo "ch11ng/exwm")
        '';

        packageRequires = [ xelb ];

        src = mkSrc "exwm";
     };
    });
  in emacsPackagesNg // overridenAttrs;
}
