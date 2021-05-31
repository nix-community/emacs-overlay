{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210531";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210531.tar";
          sha256 = "1g20rj5lafzn590q71gj482k9kla3jigm8gxxrjsq6kvb3pfz8bk";
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
        version = "20210531";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210531.tar";
          sha256 = "08zg31lfbylyv5qvwhq8ppvqsylqd005qh6zcg01vk1qrqznb5kp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
