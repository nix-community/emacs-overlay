{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210125";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210125.tar";
          sha256 = "06i0ix70p1m7qlz2yz8y5sdia94kk2j302jcxinwppl3azyfr75s";
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
        version = "20210125";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210125.tar";
          sha256 = "055fcm38s3mdxa9zml77wmjmkjldypvld56w69ma9cgc5zxqh0gx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
