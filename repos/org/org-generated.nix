{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200602";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200602.tar";
          sha256 = "1ahhb07v1w4574h80k74xpwdnqdpvr1nsm6id6mdck4f7nmjs87i";
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
        version = "20200602";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200602.tar";
          sha256 = "1wwydm6zkf3n3c0r3yan75zgq5ys7460qpzcx2zas4vmmmy383lm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }