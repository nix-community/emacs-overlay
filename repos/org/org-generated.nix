{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210809";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210809.tar";
          sha256 = "1snkk7jz6cbgdm08n24lw7q83hsf6sb1hmai064w1qxm6jrvpwh4";
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
        version = "20210809";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210809.tar";
          sha256 = "0cypf7cxj094g8bagx4zl4iw5zhn4wjqbrdy4ny59ssw57dgnr5i";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
