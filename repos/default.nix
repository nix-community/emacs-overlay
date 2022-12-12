{
  lib,
  fetchFromGitHub,
  fetchFromSavannah,
}: let
  fetchFromJson = jsonFile: let
    repoMeta = lib.importJSON jsonFile;
  in {
    src = (
      if repoMeta.type == "savannah"
      then fetchFromSavannah
      else if repoMeta.type == "github"
      then fetchFromGitHub
      else throw "Unknown repository type ${repoMeta.type}!"
    ) (builtins.removeAttrs repoMeta ["type" "version"]);
    manifest = repoMeta;
  };
in {
  emacs = {
    lsp = fetchFromJson ./emacs/emacs-lsp.json;
    master = fetchFromJson ./emacs/emacs-master.json;
    unstable = fetchFromJson ./emacs/emacs-unstable.json;
  };
}
