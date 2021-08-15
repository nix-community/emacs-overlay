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
    clojure-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "clojure-mode";
        ename = "clojure-mode";
        version = "5.13.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/clojure-mode-5.13.0.tar";
          sha256 = "16xll0sp7mqzwldfsihp7j3dlm6ps1l1awi122ff8w7xph7b0wfh";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/clojure-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    crux = callPackage ({ elpaBuild, fetchurl, lib, seq }:
      elpaBuild {
        pname = "crux";
        ename = "crux";
        version = "0.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/crux-0.4.0.tar";
          sha256 = "01yg54s2l3zr4h7h3nw408bqzrr4yds9rfgc575b76006v5d3ciy";
        };
        packageRequires = [ seq ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/crux.html";
          license = lib.licenses.free;
        };
      }) {};
    editorconfig = callPackage ({ cl-lib ? null
                                , elpaBuild
                                , emacs
                                , fetchurl
                                , lib
                                , nadvice }:
      elpaBuild {
        pname = "editorconfig";
        ename = "editorconfig";
        version = "0.8.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/editorconfig-0.8.2.tar";
          sha256 = "1ff8hwyzb249lf78j023sbibgfmimmk6mxkjmcnqqnk1jafprk02";
        };
        packageRequires = [ cl-lib emacs nadvice ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/editorconfig.html";
          license = lib.licenses.free;
        };
      }) {};
    evil = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "evil";
        ename = "evil";
        version = "1.14.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/evil-1.14.0.tar";
          sha256 = "11hzx3ya1119kr8dwlg264biixiqgvi7zwxxksql0a9hqp57rdpx";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/evil.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "geiser";
        ename = "geiser";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-0.16.tar";
          sha256 = "1mhngb1ik3qsc3w466cs61rbz3nn08ag29m5vfbd6adk60xmhnfk";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chez = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chez";
        ename = "geiser-chez";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chez-0.16.tar";
          sha256 = "016b7n5rv7fyrw4lqcprhhf2rai5vvmmc8a13l4w3a30rwcgm7cd";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chez.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chibi = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chibi";
        ename = "geiser-chibi";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chibi-0.16.tar";
          sha256 = "0j9dgg2q01ya6yawpfc15ywrfykd5gzbh118k1x4mghfkfnqn1zi";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chibi.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-chicken = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-chicken";
        ename = "geiser-chicken";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-chicken-0.16.tar";
          sha256 = "1zmb8c86akrd5f1v59s4xkbpgsqbdcbc6d5f9h6kxa55ylc4dn6a";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-chicken.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-gambit = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-gambit";
        ename = "geiser-gambit";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-gambit-0.16.tar";
          sha256 = "0bc38qlqj7a3cnrcnqrb6m3jvjh2ia5iby9i50vcn0jbs52rfsnz";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-gambit.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-gauche = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-gauche";
        ename = "geiser-gauche";
        version = "0.0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-gauche-0.0.2.tar";
          sha256 = "0wd0yddasryy36ms5ghf0gs8wf80sgdxci2hd8k0fvnyi7c3wnj5";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-gauche.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-guile = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-guile";
        ename = "geiser-guile";
        version = "0.17";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-guile-0.17.tar";
          sha256 = "0g4982rfxjp08qi6nxz73lsbdwf388fx511394yw4s7ml6v1m4kd";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-guile.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-kawa = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-kawa";
        ename = "geiser-kawa";
        version = "0.0.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-kawa-0.0.1.tar";
          sha256 = "1qh4qr406ahk4k8g46nzkiic1fidhni0a5zv4i84cdypv1c4473p";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-kawa.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-mit = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-mit";
        ename = "geiser-mit";
        version = "0.13";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-mit-0.13.tar";
          sha256 = "1y2cgrcvdp358x7lpcz8x8nw5g1y4h03d9gbkbd6k85643cwrkbi";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-mit.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-racket = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-racket";
        ename = "geiser-racket";
        version = "0.16";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-racket-0.16.tar";
          sha256 = "0lf2lbgpl8pvx7yhiydb7j5hk3kdx34zvhva4zqnzya6zf30w257";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-racket.html";
          license = lib.licenses.free;
        };
      }) {};
    geiser-stklos = callPackage ({ elpaBuild, emacs, fetchurl, geiser, lib }:
      elpaBuild {
        pname = "geiser-stklos";
        ename = "geiser-stklos";
        version = "1.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/geiser-stklos-1.3.tar";
          sha256 = "1wkhnkdhdrhrh0vipgnlmyimi859za6jhf2ldpwfmk8r2aj8ywan";
        };
        packageRequires = [ emacs geiser ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/geiser-stklos.html";
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
    go-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "go-mode";
        ename = "go-mode";
        version = "1.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/go-mode-1.5.0.tar";
          sha256 = "0v4lw5dkijajpxyigin4cd5q4ldrabljaz65zr5f7mgqn5sizj3q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/go-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    goto-chg = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "goto-chg";
        ename = "goto-chg";
        version = "1.7.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/goto-chg-1.7.4.tar";
          sha256 = "1sg2gp48b83gq0j821lk241lwyxkhqr6w5d1apbnkm3qf08qjwba";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/goto-chg.html";
          license = lib.licenses.free;
        };
      }) {};
    guru-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "guru-mode";
        ename = "guru-mode";
        version = "1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/guru-mode-1.0.tar";
          sha256 = "18vz80yc7nv6dgyyxmlxslwim7qpb1dx2y5382c2wbdqp0icg41g";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/guru-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    haskell-mode = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "haskell-mode";
        ename = "haskell-mode";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/haskell-mode-4.7.1.tar";
          sha256 = "07x7440xi8dkv1zpzwi7p96jy3zd6pdv1mhs066l8bp325516wyb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/haskell-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    highlight-parentheses = callPackage ({ elpaBuild
                                         , emacs
                                         , fetchurl
                                         , lib }:
      elpaBuild {
        pname = "highlight-parentheses";
        ename = "highlight-parentheses";
        version = "2.0.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/highlight-parentheses-2.0.3.tar";
          sha256 = "0m7jy2g1gs1xl9lzg1vfn3gmicgl41g9fq5053p6wb6i4hlb81hp";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/highlight-parentheses.html";
          license = lib.licenses.free;
        };
      }) {};
    htmlize = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "htmlize";
        ename = "htmlize";
        version = "1.56";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/htmlize-1.56.tar";
          sha256 = "0zl4d05dv8ckigqaa1y467gg1g380h183c73lx3m45hkxppjwn22";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/htmlize.html";
          license = lib.licenses.free;
        };
      }) {};
    inf-clojure = callPackage ({ clojure-mode
                               , elpaBuild
                               , emacs
                               , fetchurl
                               , lib }:
      elpaBuild {
        pname = "inf-clojure";
        ename = "inf-clojure";
        version = "3.1.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/inf-clojure-3.1.0.tar";
          sha256 = "0jw6rzplicbv2l7si46naspzp5lqwj20b1nmfs9zal58z1gx6zjk";
        };
        packageRequires = [ clojure-mode emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/inf-clojure.html";
          license = lib.licenses.free;
        };
      }) {};
    lua-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "lua-mode";
        ename = "lua-mode";
        version = "20210802";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/lua-mode-20210802.tar";
          sha256 = "1yarwai9a0w4yywd0ajdkif4g26z98zw91lg1z78qw0k61qjmnh6";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/lua-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    macrostep = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "macrostep";
        ename = "macrostep";
        version = "0.9";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/macrostep-0.9.tar";
          sha256 = "10crvq9xww4nvrswqq888y9ah3fl4prj0ha865aqbyrhhbpg18gd";
        };
        packageRequires = [ cl-lib ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/macrostep.html";
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
    multiple-cursors = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "multiple-cursors";
        ename = "multiple-cursors";
        version = "1.4.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/multiple-cursors-1.4.0.tar";
          sha256 = "0f7rk8vw42bgdf5yb4qpnrc3bxvbaafmdqd7kiiqnj5m029yr14f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/multiple-cursors.html";
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
    projectile = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "projectile";
        ename = "projectile";
        version = "2.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/projectile-2.5.0.tar";
          sha256 = "09gsm6xbqj3357vlshs1w7ygfm004gpgs0pqrvwl6xmccxpqzmi0";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/projectile.html";
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
    rubocop = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rubocop";
        ename = "rubocop";
        version = "0.6.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rubocop-0.6.0.tar";
          sha256 = "1gw30ya6xyi359k9fihjx75h7ahs067i9bvkyla0rbhmc5xdz6ww";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rubocop.html";
          license = lib.licenses.free;
        };
      }) {};
    rust-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "rust-mode";
        ename = "rust-mode";
        version = "0.5.0";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/rust-mode-0.5.0.tar";
          sha256 = "03z1nsq1s3awaczirlxixq4gwhz9bf1x5zwd5xfb88ay4kzcmjwc";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/rust-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    slime = callPackage ({ cl-lib ? null, elpaBuild, fetchurl, lib, macrostep }:
      elpaBuild {
        pname = "slime";
        ename = "slime";
        version = "2.26.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/slime-2.26.1.tar";
          sha256 = "0f7absmq0nnhhq0i8nfgn2862ydvwlqyzhcq4s6m91mn72d7dw5i";
        };
        packageRequires = [ cl-lib macrostep ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/slime.html";
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
    smartparens = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "smartparens";
        ename = "smartparens";
        version = "4.7.1";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/smartparens-4.7.1.tar";
          sha256 = "0si9wb7j760c4vdv7p049bgppppw5crrh50038bsh8sghq2gdld8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/smartparens.html";
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
    web-mode = callPackage ({ elpaBuild, emacs, fetchurl, lib }:
      elpaBuild {
        pname = "web-mode";
        ename = "web-mode";
        version = "17.0.4";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/web-mode-17.0.4.tar";
          sha256 = "0ji40fcw3y2n4dw0cklbvsybv04wmfqfnqnykgp05aai388rp3j1";
        };
        packageRequires = [ emacs ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/web-mode.html";
          license = lib.licenses.free;
        };
      }) {};
    wgrep = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "wgrep";
        ename = "wgrep";
        version = "2.3.3";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/wgrep-2.3.3.tar";
          sha256 = "12w9vsawqnd0rvsahx8vdiabds8rl1zkpmspmcqn28jprbql734r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/wgrep.html";
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
    yasnippet-snippets = callPackage ({ elpaBuild, fetchurl, lib, yasnippet }:
      elpaBuild {
        pname = "yasnippet-snippets";
        ename = "yasnippet-snippets";
        version = "0.2";
        src = fetchurl {
          url = "https://elpa.nongnu.org/nongnu/yasnippet-snippets-0.2.tar";
          sha256 = "1xhlx2n2sdpcc82cba9r7nbd0gwi7m821p7vk0vnw84dhwy863ic";
        };
        packageRequires = [ yasnippet ];
        meta = {
          homepage = "https://elpa.gnu.org/packages/yasnippet-snippets.html";
          license = lib.licenses.free;
        };
      }) {};
  }
