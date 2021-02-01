{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210201";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210201.tar";
          sha256 = "1iyfk6q5xv70p7rrnz7bcyj2hx5q6iz05p56mahi9mvpbp18q3kb";
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
        version = "20210201";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210201.tar";
          sha256 = "1x5fnp9ffy241whhgj5vjcxq1lq7apmxpppf79y1hf0i2pfhkdpp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
