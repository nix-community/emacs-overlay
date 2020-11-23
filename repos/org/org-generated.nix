{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201123";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201123.tar";
          sha256 = "0jknzliz24w3cgfpll83xgyg3yzvqa465wbrvg2asmkxmnsy474b";
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
        version = "20201123";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201123.tar";
          sha256 = "03haql6kdv5063cy3vvfnqjga5jjfz51w9iyn37ay04ymwkjw5dm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }