{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210705";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210705.tar";
          sha256 = "0ipzvqwh4frncsrfl83hj8cb38k7bj6dgj0crxm8drvb22w55vzz";
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
        version = "20210705";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210705.tar";
          sha256 = "139v94kd2bp3dajffz6kziy6sqiwxjyfzw61mhikrd88gnwl0p2d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
