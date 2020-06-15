{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200615";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200615.tar";
          sha256 = "1xdhrl0gksrn4djvpra2mhxihm1rv2akj7y4axh6xa25lrkw6rdi";
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
        version = "20200615";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200615.tar";
          sha256 = "097i86dgas6rdsyq3dg5hw1yzgxrg5106nzynhhiy02wi94fx7j2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }