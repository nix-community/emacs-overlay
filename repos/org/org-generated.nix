{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200608";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200608.tar";
          sha256 = "0cy5hj3ajn12jj20cbh3d383v7blw285693mf9dmfck9pwnfi1mz";
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
        version = "20200608";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200608.tar";
          sha256 = "0bkhl127c0h85h6dj6ij28qy943g5fscaadhcir60094bz20ca90";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }