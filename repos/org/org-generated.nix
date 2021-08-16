{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210816";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210816.tar";
          sha256 = "026j9w6rzy4skbr23hxd7lcj74js0z2r9g02gz1kvc40ncxk4nqv";
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
        version = "20210816";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210816.tar";
          sha256 = "07is7dkj32vnahk1l50cmmipvif08kv4gy9glvybwl6ihmw7l6q4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
