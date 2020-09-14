{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200914";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200914.tar";
          sha256 = "1lk0by7fk97dyxp0jpi4svp1mljv8yxxily77cdlpzy9bln3bf2r";
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
        version = "20200914";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200914.tar";
          sha256 = "1naq25g4d95cx29axx428rnpc4m9hd0j7w1l0vqwkdjyr5qfj0ab";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }