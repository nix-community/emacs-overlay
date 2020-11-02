{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201102";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201102.tar";
          sha256 = "0dsjscy8bh5lcgcld1wz4i14gzs0mlpwyqz65bbmyka2pr7sh0ys";
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
        version = "20201102";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201102.tar";
          sha256 = "000rds82bi4f5hqasnawl9h9dp1187k9v1c9l1hrx0nhmzv1amax";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }