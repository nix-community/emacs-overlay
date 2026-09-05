self: super:
let
  inherit (super) lib;

  missingPackageRequires = {
    ac-geiser = { variants = [ "unstable" ]; deps = [ "auto-complete" "geiser" ]; };
    achievements = { variants = [ "unstable" ]; deps = [ "keyfreq" ]; };
    auto-complete = { variants = [ "stable" ]; deps = [ "popup" ]; };
    boon = { variants = [ "stable" ]; deps = [ "dash" "expand-region" "multiple-cursors" ]; };
    cacoo = { variants = [ "stable" "unstable" ]; deps = [ "concurrent" ]; };
    dpkg-dev-el = { variants = [ "stable" ]; deps = [ "debian-el" ]; };
    drill-instructor-AZIK-force = { variants = [ "unstable" ]; deps = [ "popup" ]; };
    ecukes = { variants = [ "stable" ]; deps = [ "ansi" "commander" "dash" "espuds" "f" "s" ]; };
    edbi = { variants = [ "stable" "unstable" ]; deps = [ "concurrent" "ctable" "epc" ]; };
    ego = { variants = [ "unstable" ]; deps = [ "dash" "ht" "htmlize" "mustache" "org" ]; };
    el-sprunge = { variants = [ "unstable" ]; deps = [ "htmlize" "web-server" ]; };
    elnode = {
      variants = [ "unstable" ];
      deps = [ "creole" "dash" "db" "fakir" "kv" "noflet" "s" "web" ];
    };
    eval-in-repl = { variants = [ "stable" ]; deps = [ "ace-window" "dash" "paredit" ]; };
    evil = { variants = [ "stable" ]; deps = [ "goto-chg" ]; };
    fiplr = { variants = [ "stable" "unstable" ]; deps = [ "grizzl" ]; };
    gh = { variants = [ "stable" ]; deps = [ "logito" "marshal" "pcache" ]; };
    graphene = {
      variants = [ "stable" "unstable" ];
      deps = [
        "company"
        "dash"
        "exec-path-from-shell"
        "flycheck"
        "graphene-meta-theme"
        "ido-completing-read+"
        "ppd-sr-speedbar"
        "smartparens"
        "smex"
        "sr-speedbar"
        "web-mode"
      ];
    };
    ivy-erlang-complete = { variants = [ "stable" ]; deps = [ "async" "counsel" "erlang" "ivy" ]; };
    lispy = {
      variants = [ "stable" "unstable" ];
      deps = [ "ace-window" "hydra" "iedit" "swiper" "zoutline" ];
    };
    nnreddit = {
      variants = [ "unstable" ];
      deps = [ "anaphora" "dash" "json-rpc" "request" "s" "virtualenvwrapper" ];
    };
    nntwitter = { variants = [ "unstable" ]; deps = [ "anaphora" "dash" "request" ]; };
    org-ehtml = { variants = [ "unstable" ]; deps = [ "web-server" ]; };
    org-page = { variants = [ "stable" ]; deps = [ "ht" "htmlize" "mustache" "org" ]; };
    pi-coding-agent = { variants = [ "stable" "unstable" ]; deps = [ "magit-section" "markdown-table-wrap" "md-ts-mode" "transient" ]; };
    ppd-sr-speedbar = {
      variants = [ "stable" "unstable" ];
      deps = [ "project-persist-drawer" "sr-speedbar" ];
    };
    project-persist-drawer = { variants = [ "stable" "unstable" ]; deps = [ "project-persist" ]; };
    smartparens = { variants = [ "stable" ]; deps = [ "dash" ]; };
    zotxt = { variants = [ "stable" ]; deps = [ "deferred" "request" ]; };
  };
in
{
  emacsPackagesFor = emacs: (
    (super.emacsPackagesFor emacs).overrideScope (
      eself: esuper:
        let
          addMissingPackageRequires = variant: { base, final }:
            lib.mapAttrs
              (ename: spec: base.${ename}.overrideAttrs (old: {
                packageRequires =
                  old.packageRequires or [ ] ++ map (dep: final.${dep} or eself.${dep}) spec.deps;
              }))
              (lib.filterAttrs (_: spec: builtins.elem variant spec.variants) missingPackageRequires);

          melpaStablePackages =
            let
              base = esuper.melpaStablePackages.override {
                archiveJson = ../repos/melpa/recipes-archive-melpa.json;
              };
            in
            base // addMissingPackageRequires "stable" {
              inherit base;
              final = eself.melpaStablePackages;
            };

          melpaPackages =
            let
              base = esuper.melpaPackages.override {
                archiveJson = ../repos/melpa/recipes-archive-melpa.json;
              };
            in
            base // addMissingPackageRequires "unstable" {
              inherit base;
              final = eself.melpaPackages;
            };

          elpaDevelPackages = esuper.elpaDevelPackages.override {
            generated = ../repos/elpa/elpa-devel-generated.nix;
          };

          elpaPackages = esuper.elpaPackages.override {
            generated = ../repos/elpa/elpa-generated.nix;
          };

          nongnuDevelPackages = esuper.nongnuDevelPackages.override {
            generated = ../repos/nongnu/nongnu-devel-generated.nix;
          };

          nongnuPackages = esuper.nongnuPackages.override {
            generated = ../repos/nongnu/nongnu-generated.nix;
          };

        in
          esuper.override {
            inherit melpaStablePackages melpaPackages elpaDevelPackages elpaPackages
              nongnuDevelPackages nongnuPackages;
          }

    )
  );

}
