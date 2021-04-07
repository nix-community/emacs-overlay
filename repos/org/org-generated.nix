{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210405";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210405.tar";
          sha256 = "0iy8sf5n0sirb4s2igsrpv34c1wiyxiqspkrqpi1yvq9q7f5nnx6";
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
        version = "20210405";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210405.tar";
          sha256 = "1lab8c6hadg1wkf6vl4czd35dnv7llmwfyzyy8lfc7f5jyipnzbl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
