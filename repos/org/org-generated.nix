{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200716";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200716.tar";
          sha256 = "1znq09qyflywirc00756zlzmx7dry6s753iijpsv7g1282vbb7x6";
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
        version = "20200716";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200716.tar";
          sha256 = "1qv3f8s8ppf2kjivjpz211v3kknv01fjwv17hznzachdp8ccvfk5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }