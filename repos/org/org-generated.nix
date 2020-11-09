{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201109";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201109.tar";
          sha256 = "1f9rmdn0zsng17ghv8awx3aghwhq8dnjm9a9klvshr8zqysx7vbr";
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
        version = "20201109";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201109.tar";
          sha256 = "00pc2rb0ribm4qhcwj3nnv4cfr4jxiryzixlzdx7lhigbkldxd2f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }