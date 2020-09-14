{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200914";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200914.tar";
          sha256 = "0qjpwi5qw7531pzqz36v1djrxp0ibxp8ihlp7ib5par2rif7whf0";
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
          sha256 = "1v9bgbqpjkmypp4ff3s64gd1ql790h3v3xkz3v49pmxw0zv8v1j6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }