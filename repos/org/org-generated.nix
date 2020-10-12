{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201012";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201012.tar";
          sha256 = "1s302zxpb2r8yqpymy2n66zqmq0m22n21d4yyhq3x2dpzdy32rhw";
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
        version = "20201012";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201012.tar";
          sha256 = "085hj8dj9yjdjrcsgv0vcbw19ah3vksvyrsdgcnhbjqak30x4afp";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }