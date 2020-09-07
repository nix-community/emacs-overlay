{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200907";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200907.tar";
          sha256 = "0ji2bww77cmcjr3ppflx2q82dqvhf341imj9zhq134ff05ghdpwm";
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
        version = "20200907";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200907.tar";
          sha256 = "1f2471klf0v90irpp80413y4v6mhf9bwmrirdilk7qz2p1l6wf4z";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }