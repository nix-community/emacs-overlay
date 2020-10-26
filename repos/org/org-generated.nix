{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201026";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201026.tar";
          sha256 = "0pnjv8wdcpndb12yxk5c5k9agx9k0g1j7xjzz9jcj4nsmq6sm1lv";
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
        version = "20201026";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201026.tar";
          sha256 = "1sgd36j4ab1psy4lda1ijlyfxpwsm45gm3bf9nb25baqizi93xbf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }