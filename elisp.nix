/*
Parse an emacs lisp configuration file to derive packages from
use-package declarations.
*/

{ pkgs }:

let
  isStrEmpty = s: (builtins.replaceStrings [" "] [""] s) == "";

  splitString = _sep: _s: builtins.filter
    (x: builtins.typeOf x == "string")
    (builtins.split _sep _s);

  stripComments = dotEmacs: let
    lines = splitString "\n" dotEmacs;
    stripped = builtins.map (l:
      builtins.elemAt (splitString ";;" l) 0) lines;
  in builtins.concatStringsSep " " stripped;

  parsePackages = dotEmacs: let
    strippedComments = stripComments dotEmacs;
    tokens = builtins.filter (t: !(isStrEmpty t)) (builtins.map
      (t: if builtins.typeOf t == "list" then builtins.elemAt t 0 else t)
      (builtins.split "([\(\)])" strippedComments));
    matches = builtins.map (t:
      builtins.match "^use-package[[:space:]]+([A-Za-z0-9_-]+).*" t) tokens;
  in builtins.map (m: builtins.elemAt m 0)
      (builtins.filter (m: m != null) matches);

in {
  config,
  extraEmacsPackages ? epkgs: [],
  package ? pkgs.emacs,
  override ? (epkgs: epkgs)
}: let
  packages = parsePackages config;
  emacsPackages = pkgs.emacsPackagesNgGen package;
  emacsWithPackages = emacsPackages.emacsWithPackages;
in emacsWithPackages (epkgs: let
  overriden = override epkgs;
  usePkgs = builtins.map (name: overriden.${name}) packages;
  extraPkgs = extraEmacsPackages overriden;
in [ overriden.use-package ] ++ usePkgs ++ extraPkgs)
