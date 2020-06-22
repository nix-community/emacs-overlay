{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200622";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200622.tar";
          sha256 = "1l9imgyr95xa0n9cz40h0lcdi5m8v83l046bcxrxy0d38jab17ac";
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
        version = "20200622";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200622.tar";
          sha256 = "0srhgmj45wnpzvryjqrjm6zlx021sb78cpl4jzjj4n8fp8py0mp8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }