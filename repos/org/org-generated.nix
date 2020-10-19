{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201019";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201019.tar";
          sha256 = "0d1nkm9g6w8l6arln0gpnmj63pydlgkmaw7cag2kzpyvhq536a1l";
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
        version = "20201019";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201019.tar";
          sha256 = "1k2j7m2ccap5lrppj8c1wkfvn1ww31cc5f04z3snfl4zslm2574n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }