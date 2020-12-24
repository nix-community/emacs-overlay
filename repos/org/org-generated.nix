{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201222";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201222.tar";
          sha256 = "0ngqc8dy5ah6agf3a0f3scihzwkwg7bgkzjljkzfzcmy8833b5n5";
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
        version = "20201222";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201222.tar";
          sha256 = "1pa8h5dpi5yj3j7v0aaby8sjwxvmgnbip2ilyl5pac1rlbz0jn40";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
