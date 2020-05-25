{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200525";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200525.tar";
          sha256 = "1c4769ndf7r3c33h2l78sm0rrndyww1d9nk71b3nkr67cn9zhmkz";
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
        version = "20200525";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200525.tar";
          sha256 = "0rfbmgwvbf5djzpxmqmwf31dhkl6dh5dyg3lmsrlcj74ng03vblk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }