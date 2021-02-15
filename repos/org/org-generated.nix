{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210215";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210215.tar";
          sha256 = "0gr9cbpzy5gb5rxwq8dl01vyzslpjxsd5v04s4ggdlbinq7a6b0g";
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
        version = "20210215";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210215.tar";
          sha256 = "0cb72jpmfzxpbrj0sfd5rjyqyp52a1bhxw6vahpzkgdjnls3dqy5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
