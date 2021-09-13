{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210913";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210913.tar";
          sha256 = "12kvvgbmaggmbdcw24xbnds1ivnljx4jciar2frzhbr8imfyas70";
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
        version = "20210913";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210913.tar";
          sha256 = "12f5xr1rkbg1z0ikh54lpx8ghyi1wji92wlg05wwvqgcrzanq7n6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
