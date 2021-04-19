{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210419";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210419.tar";
          sha256 = "020hhg6l1hfaj613r8pc8zcmaznv8fkwwd7yvvmdkhiki87fdp2l";
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
        version = "20210419";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210419.tar";
          sha256 = "0ihh68hhby0i1lkhpp90v3fznnjf3jz6f98xp2r68vrgjhygjkdx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
