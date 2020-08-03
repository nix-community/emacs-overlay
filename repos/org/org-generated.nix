{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200803";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200803.tar";
          sha256 = "0vqrbwa0jb88lqr7qxj0l8qynjwnmyaf77c1kdcpqrbc36mr2jqy";
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
        version = "20200803";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200803.tar";
          sha256 = "0pfb6dk2q0lv57acamll9lgq3faddpmjlzb6g3djgnwz6zxqsp8q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }