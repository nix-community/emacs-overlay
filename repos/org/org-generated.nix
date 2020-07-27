{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200727";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200727.tar";
          sha256 = "0fcmjwxyfin3mcc2jyb00qghcn81zrw888rlc4fzfzlc50nwvk66";
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
        version = "20200727";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200727.tar";
          sha256 = "1dgrpgisa0ya75rdkcrr2l6z1abk1f0zvnb5k0c8k1nszr31ylik";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }