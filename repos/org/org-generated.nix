{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201212";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201212.tar";
          sha256 = "1h3firrvnzkwxl2c78wzxk1qjnvbrvhpianydrx5kzn4a2n2xjc8";
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
        version = "20201212";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201212.tar";
          sha256 = "110wx1ywb542wg3984cknvbc7njsxd594c6q3y3nf3lqp99wndib";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }