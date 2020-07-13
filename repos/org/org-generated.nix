{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200713";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200713.tar";
          sha256 = "1jm8pvabczylzwz06h3h3x5asiizs5vrb8pvwlm5pyid5lzzvnnq";
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
        version = "20200713";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200713.tar";
          sha256 = "159ppiwyviysk0n0s2vb9kzb8rqcn6c37xafxfcgr2lc4pwincg9";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }