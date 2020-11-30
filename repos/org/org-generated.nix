{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201130";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201130.tar";
          sha256 = "0m1w7ssp820awmdbpvcdj3nj6dyjfn4ll1nswr8d0xdyli410ayr";
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
        version = "20201130";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201130.tar";
          sha256 = "062nzvz0yw2af4rhyfvgysc7y7p252dy6bxgj57z7l8qvgb8yx2q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }