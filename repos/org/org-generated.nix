{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201005";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201005.tar";
          sha256 = "1jdql9kk9451p5q77rgn0k4pd47hjnsmrir3snbgbmi3f8xcdgmx";
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
        version = "20201005";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201005.tar";
          sha256 = "08flsfcb2qlksip1aamvxanyxs7n2m2hg56772cag2hyl81mzs0f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }