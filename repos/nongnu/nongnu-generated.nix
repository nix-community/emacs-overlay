{ callPackage }:
  {
    caml = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "caml";
        ename = "caml";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/caml-4.7.1.tar";
          sha256 = "1bv2fscy7zg7r1hyg4rpvh3991vmhy4zid7bv1qbhxa95m9c49j3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/caml.html";
          license = lib.licenses.free;
        };
      }) {};
    git-commit = callPackage ({ dash
                              , elpaBuild
                              , emacs
                              , fetchurl
                              , lib
                              , transient
                              , with-editor }:
      elpaBuild {
        pname = "git-commit";
        ename = "git-commit";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/git-commit-3.2.1.tar";
          sha256 = "1jndc8ppj4r2s62idabygj4q0qbpk4gwifn8jrd6pa61d7dlvp28";
        };
        packageRequires = [ dash emacs transient with-editor ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/git-commit.html";
          license = lib.licenses.free;
        };
      }) {};
    magit = callPackage ({ dash
                         , elpaBuild
                         , emacs
                         , fetchurl
                         , git-commit
                         , lib
                         , magit-section
                         , transient
                         , with-editor }:
      elpaBuild {
        pname = "magit";
        ename = "magit";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/magit-3.2.1.tar";
          sha256 = "0yyf16605bp5q8jl2vbljxx04ja0ljvs775dnnawlc3mvn13zd9n";
        };
        packageRequires = [
          dash
          emacs
          git-commit
          magit-section
          transient
          with-editor
        ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/magit.html";
          license = lib.licenses.free;
        };
      }) {};
    magit-section = callPackage ({ dash, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "magit-section";
        ename = "magit-section";
        version = "3.2.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/magit-section-3.2.1.tar";
          sha256 = "1ppinys8rfa38ac8grcx16hlaw33p03pif4ya6bbw280kq8c73rv";
        };
        packageRequires = [ dash emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/magit-section.html";
          license = lib.licenses.free;
        };
      }) {};
    markdown-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "markdown-mode";
        ename = "markdown-mode";
        version = "2.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/markdown-mode-2.4.tar";
          sha256 = "002nvc2p7jzznr743znbml3vj8a3kvdd89rlbi28f5ha14g2567z";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/markdown-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    org-contrib = callPackage ({ elpaBuild, emacs, fetchurl, lib, org }:
      elpaBuild {
        pname = "org-contrib";
        ename = "org-contrib";
        version = "0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/org-contrib-0.1.tar";
          sha256 = "07hzywvgj11wd21dw4lbkvqv32da03407f9qynlzgg1qa7wknm2k";
        };
        packageRequires = [ emacs org ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
    request = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "request";
        ename = "request";
        version = "0.3.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/request-0.3.3.tar";
          sha256 = "168yy902bcjfdaahsbzhzb4wgqbw1mq1lfwdjh66fpzqs75c5q00";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/request.html";
          license = lib.licenses.free;
        };
      }) {};
    sly = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "sly";
        ename = "sly";
        version = "1.0.43";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/sly-1.0.43.tar";
          sha256 = "0qgji539qwk7lv9g1k11w0i2nn7n7nk456gwa0bh556mcqz2ndr8";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/sly.html";
          license = lib.licenses.free;
        };
      }) {};
    tuareg = callPackage ({ caml, elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "tuareg";
        ename = "tuareg";
        version = "2.3.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/tuareg-2.3.0.tar";
          sha256 = "0a24q64yk4bbgsvm56j1y68zs9yi25qyl83xydx3ff75sk27f1yb";
        };
        packageRequires = [ caml emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/tuareg.html";
          license = lib.licenses.free;
        };
      }) {};
    with-editor = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "with-editor";
        ename = "with-editor";
        version = "3.0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/with-editor-3.0.4.tar";
          sha256 = "032i954rzn8sg1qp6vjhz6j8j1fl6mpvhfnmd3va8k9q9m27k4an";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/with-editor.html";
          license = lib.licenses.free;
        };
      }) {};
  }
