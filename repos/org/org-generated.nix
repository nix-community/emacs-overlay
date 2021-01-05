{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210104";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210104.tar";
          sha256 = "1jlm4sy55q6ys2w6b26hnnn695nxss4z6x2q2dfdgdfb1npvxxfr";
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
        version = "20210104";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210104.tar";
          sha256 = "0rqz8na3ldc57b8v6r34mxmaj73v3rgqg6rysk4vgy1fp0cvhsyz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
