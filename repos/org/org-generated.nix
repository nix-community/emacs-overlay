{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200720";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200720.tar";
          sha256 = "1yr41zai9bzjrxa1ncc06xmjxsw6agr4nkyp048fspxhqh8fqxvk";
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
        version = "20200720";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200720.tar";
          sha256 = "04lm4vlb1qj3bn7mvbclx3zsdpm1jqlk7kmj2w6pf2scif4fw4dj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }