{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201116";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201116.tar";
          sha256 = "151biqx7crxcjk3skpa0hm2g0i384ikaf7fi19mpf14d3zb1h9l7";
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
        version = "20201116";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201116.tar";
          sha256 = "1pxwnlaziwa16dspzzgkvlj282ss94f05nax9pgsi3mmaziapidx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }