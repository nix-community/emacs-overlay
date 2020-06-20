{ lib }:
let
  isStrEmpty = s: (builtins.replaceStrings [ " " ] [ "" ] s) == "";

  splitString = _sep: _s: builtins.filter
    (x: builtins.typeOf x == "string")
    (builtins.split _sep _s);

  # Parse (all) Package-Requires elisp headers found in the input string
  # `packageFile` into a list of package name strings.
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
  parsePackagesFromPackageRequires = packageFile:
    let
      lines = splitString "\r?\n" packageFile;
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

  stripComments = dotEmacs:
    let
      lines = splitString "\n" dotEmacs;
      stripped = builtins.map
        (l:
          builtins.elemAt (splitString ";;" l) 0)
        lines;
    in
    builtins.concatStringsSep " " stripped;

  parsePackagesFromUsePackage = dotEmacs:
    let
      strippedComments = stripComments dotEmacs;
      tokens = builtins.filter (t: !(isStrEmpty t)) (builtins.map
        (t: if builtins.typeOf t == "list" then builtins.elemAt t 0 else t)
        (builtins.split "([\(\)])" strippedComments)
      );
      matches = builtins.map
        (t:
          builtins.match "^use-package[[:space:]]+([A-Za-z0-9_-]+).*" t)
        tokens;
    in
    builtins.map
      (m: builtins.elemAt m 0)
      (builtins.filter (m: m != null) matches);

in
{
  inherit parsePackagesFromPackageRequires;
  inherit parsePackagesFromUsePackage;
}
