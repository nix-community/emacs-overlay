{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201216";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201216.tar";
          sha256 = "05i0q494fpiw6hgqpiky6s59da24zrv0f5anxvvdbcsxaa3mnfq3";
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
        version = "20201216";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201216.tar";
          sha256 = "0p7bmgw4shbyzxp6lbbnqxrrzll0lwfd64hqrr97gfvigm4bc16g";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }