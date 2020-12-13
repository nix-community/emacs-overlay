{ pkgs, lib }:

let
  inherit (import ./repos/fromElisp { inherit pkgs; }) fromElisp fromOrgModeBabelElisp';

  isStrEmpty = s: (builtins.replaceStrings [ " " ] [ "" ] s) == "";

  splitString = _sep: _s: builtins.filter
    (x: builtins.typeOf x == "string")
    (builtins.split _sep _s);

  # Parse (all) Package-Requires packageElisp headers found in the input string
  # `packageElisp` into a list of package name strings.
  #
  # Example inputs:
  #
  #  ;; Package-Requires: ()
  #  => [ ]
  #  ;; Package-Requires: ((dash "2.12.1") (pkg-info "0.4") (let-alist "1.0.4") (seq "1.11") (emacs "24.3"))
  #  => [ "dash" "pkg-info" "let-alist" "seq" "emacs" ]
  #  ;; Package-Requires: (dash (pkg-info "0.4"))
  #  => [ "dash" "pkg-info" ]
  #  ;; Package-Requires: ((dash) (pkg-info "0.4"))
  #  => [ "dash" "pkg-info" ]
  parsePackagesFromPackageRequires = packageElisp:
    let
      lines = splitString "\r?\n" packageElisp;
      requires =
        lib.concatMapStrings
          (line:
            let match = builtins.match ";;;* *[pP]ackage-[rR]equires *: *\\((.*)\\) *" line;
            in if match == null then "" else builtins.head match)
          lines;
      parseReqList = s:
        let matchAndRest = builtins.match " *\\(? *([^ \"\\)]+)( +\"[^\"]+\" *\\)| *\\))?(.*)" s;
        in
        if isStrEmpty s then
          [ ]
        else
          if matchAndRest == null then
            throw "Failed to parse package requirements list: ${s}"
          else
            [ (builtins.head matchAndRest) ] ++ (parseReqList (builtins.elemAt matchAndRest 2));
    in
    parseReqList requires;

  # Get a list of packages declared wanted with `use-package` in the
  # input string `config`. The goal is to only list packages that
  # would be installed by `use-package` on evaluation; thus we look at
  # the `:ensure` and `:disabled` keyword values to attempt to figure
  # out which and whether the package should be installed.
  #
  # Example input:
  #
  # ''
  #   (use-package org
  #     :commands org-mode
  #     :bind (("C-c a" . org-agenda)
  #            :map org-mode-map
  #            ([C-right] . org-demote-subtree)
  #            ([C-left] . org-promote-subtree)))
  #
  #   (use-package direnv
  #     :ensure t
  #     :config (direnv-mode))
  #
  #   (use-package paredit-mode
  #     :ensure paredit
  #     :hook (emacs-lisp-mode lisp-mode lisp-interaction-mode))
  # ''
  # => [ "direnv" "paredit" ]
  parsePackagesFromUsePackage = {
    configText
    , alwaysEnsure ? false
    , isOrgModeFile ? false
    , alwaysTangle ? false
  }:
    let
      readFunction =
        if isOrgModeFile then
          fromOrgModeBabelElisp' { ":tangle" = if alwaysTangle then "yes" else "no"; }
        else
          fromElisp;

      find = item: list:
        if list == [] then [] else
          if builtins.head list == item then
            list
          else
            find item (builtins.tail list);

      getKeywordValue = keyword: list:
        let
          keywordList = find keyword list;
        in
          if keywordList != [] then
            let
              keywordValue = builtins.tail keywordList;
            in
              if keywordValue != [] then
                builtins.head keywordValue
              else
                true
          else
            null;

      isDisabled = item:
        let
          disabledValue = getKeywordValue ":disabled" item;
        in
          if disabledValue == [] then
            false
          else if builtins.isBool disabledValue then
            disabledValue
          else if builtins.isString disabledValue then
            true
          else
            false;

      getName = item:
        let
          ensureValue = getKeywordValue ":ensure" item;
          usePackageName = builtins.head (builtins.tail item);
        in
          if builtins.isString ensureValue then
            if lib.hasPrefix ":" ensureValue then
              usePackageName
            else
              ensureValue
          else if ensureValue == true || (ensureValue == null && alwaysEnsure) then
            usePackageName
          else
            [];

      recurse = item:
        if builtins.isList item && item != [] then
          let
            packageManager = builtins.head item;
          in
            if builtins.elem packageManager [ "use-package" "leaf" ] then
              if !(isDisabled item) then
                [ packageManager (getName item) ] ++ map recurse item
              else
                []
            else
              map recurse item
        else
          [];
    in
      lib.flatten (map recurse (readFunction configText));

in
{
  inherit parsePackagesFromPackageRequires;
  inherit parsePackagesFromUsePackage;
}
