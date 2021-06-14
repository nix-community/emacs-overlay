{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210614";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210614.tar";
          sha256 = "08yv6brbzbr1x9ydsv5igvdj3mr1i2cqaqy6x692lagbp77kq572";
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
        version = "20210614";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210614.tar";
          sha256 = "1zpnfci7v5i3f53wq6pwzrl2ax0j71qxp2xx1iiwn2ny8w5jij0x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
