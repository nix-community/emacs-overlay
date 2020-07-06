{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200706";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200706.tar";
          sha256 = "030hbbqzfxx78212i02li2wpm0qicymmb7zqy70k53jxs6v1inp1";
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
        version = "20200706";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200706.tar";
          sha256 = "1djfqvhvf64l9hkm1jc9vk5z20ra9dcavnqg99jr2cv3vsv0klfi";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }