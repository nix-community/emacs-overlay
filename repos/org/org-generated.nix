{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200928";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200928.tar";
          sha256 = "14jr1cj2i9b2nraxv19x70z1py08xz7imhji9wfqa9qaawjh5qkl";
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
        version = "20200928";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200928.tar";
          sha256 = "0y8l7k0wwdbym5p5yrps3q3x0hqd8k0x2mklq6zha3psg76dbk6y";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }