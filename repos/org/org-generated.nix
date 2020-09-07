{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200907";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200907.tar";
          sha256 = "1bzj10kyaxyawv05yma2jiahwgnmhjrps7ysry8vlfxizrd7ffy6";
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
        version = "20200907";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200907.tar";
          sha256 = "1rgk3pwhsmbmwlncg60ahwrrkm1ks4xpwy2wzv9q7myl1aihjj54";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }