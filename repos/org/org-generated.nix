{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201214";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201214.tar";
          sha256 = "0xbcnqk4nxlf1xlabv66n4l0q3n79p6azpq46ra27a1ckd8dihn3";
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
        version = "20201214";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201214.tar";
          sha256 = "0zfgjijs1r3q9b18c7c4x2ra1fw35y1c92s086fjpdyw9ldb3s2k";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }