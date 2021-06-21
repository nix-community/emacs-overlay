{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210621";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210621.tar";
          sha256 = "0n600kn01wk5r5wlndpm9s56xmyndbjmkf1jqsa9d4rh5i1yz6cz";
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
        version = "20210621";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210621.tar";
          sha256 = "1fzjqg3rrivmmpk4js1a3yp1nzxlwy9srqfz0f8w2n1w113ip5d6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
