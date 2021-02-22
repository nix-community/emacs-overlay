{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210222";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210222.tar";
          sha256 = "1xxbyfcwfh28d6l5xz340nw80yads8zdqnpl4fyfwnd14pl1ygn7";
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
        version = "20210222";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210222.tar";
          sha256 = "1skyqdi3878s4nbqskb48d2y124d5k63bl5kj0avf8l5fy9k5n4w";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
