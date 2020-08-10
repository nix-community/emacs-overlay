{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200810";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200810.tar";
          sha256 = "0q7m7d0wk1hwyqa6jhychgn0gqbj9i40cbrzxp760rfn0nihiy1i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org-plus-contrib";
        ename = "org-plus-contrib";
        version = "20200810";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200810.tar";
          sha256 = "1fpg6gdr0sjj4ys7j7igjqfjpv4fybiq1hi70jgqbky5gawq1y0n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }