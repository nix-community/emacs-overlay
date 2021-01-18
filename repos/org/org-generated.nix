{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210118";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210118.tar";
          sha256 = "183byd2kh7bhns8gzp6sans7phw8npk5875zvlbsj7ryqj0x8g97";
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
        version = "20210118";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210118.tar";
          sha256 = "0hni8fac6dkzm0yl0jjcba596whf5fk14d57g6b2r03q3ma9v1rs";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
