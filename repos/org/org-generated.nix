{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210802";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210802.tar";
          sha256 = "0764kbi3qr210kj93n5mrpg0nyfp6dxzi0l7ilfag8jngsba2kfy";
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
        version = "20210802";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210802.tar";
          sha256 = "1fyv8q2234mv7rhbsakpvgixxhp1y337c2djb1phhzv1wrqkrypw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
