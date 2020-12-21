{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201221";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201221.tar";
          sha256 = "1n9pczd48pdyzm1dpmgbin1d3bzdqx5b895dxw7hf57yx4cxs74s";
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
        version = "20201221";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201221.tar";
          sha256 = "1rmzmvx9939phk94ahcw60kv6f50bvnyvnngss3qxia7g9l33dcj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }