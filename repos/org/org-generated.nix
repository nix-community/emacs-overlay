{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200629";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200629.tar";
          sha256 = "11wzwwcxi7gcmb4pfpxmbi73fma8bw58lh74mkwkfmcq22c4qfxr";
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
        version = "20200629";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200629.tar";
          sha256 = "1d8s21d12m7q61vcpiyd1bxz0n6ch9rmrnm5r5caf73wscvz2d0n";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }