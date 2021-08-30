{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210830";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210830.tar";
          sha256 = "1hzyl73pm7z6bw4zci7gq17jjrmigsixqmc2f3vk4nh920l45ir0";
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
        version = "20210830";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210830.tar";
          sha256 = "0bsw10r1wba75xpsiqr045n1llbz3pp8s7xns533m3vzvljdyqqh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
