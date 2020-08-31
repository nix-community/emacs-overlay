{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200831";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200831.tar";
          sha256 = "1p3h141ywlqdlr9qdg01bsqzfhfk0l5b1vyvik6n54aw48h747k6";
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
        version = "20200831";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200831.tar";
          sha256 = "0h72ppv0z2jf8a259wmyk2zsfj0xw66m0qsfn3mnw6ksgdamqk4l";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }