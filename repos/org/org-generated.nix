{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200824";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200824.tar";
          sha256 = "0divzmw3appz4mixpnqqhk5jwmssi326ss7ifdzr5nbsi13v7lss";
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
        version = "20200824";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200824.tar";
          sha256 = "05kwbz5n9qm4dw0wjv5qhq9qdq27hl720la0m21792nknaxzffva";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }