{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200518";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200518.tar";
          sha256 = "0p7i90861bppf6drri27lzykcwvygvbxm882fmjpyxd9jfm5q6yh";
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
        version = "20200518";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200518.tar";
          sha256 = "08ax77bmjwziqb9p2n0g93bl2xwyl7xwblg5vg2wryl1bmrm1p0q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }