{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210426";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210426.tar";
          sha256 = "1v081li9ps1nzagg70f2hk5pn1kjcw5y6dnx9ljvvmawnigmv73h";
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
        version = "20210426";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210426.tar";
          sha256 = "10qzcsildbzq6vgm4rvhblc3hm0s57z8sxrj9y3vcai3dcpj031r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
