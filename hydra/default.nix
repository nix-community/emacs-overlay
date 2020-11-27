{ nixpkgs, declInput }:
let
  pkgs = import nixpkgs {};

  mkJobset = {
    nixpkgsRelease
    , nixFile
    , descriptionNote
  }: {
    enabled = 1;
    hidden = false;
    description = "Emacs-overlay jobset for nixpkgs branch ${nixpkgsRelease} (${descriptionNote})";
    nixexprinput = "src";
    nixexprpath = "hydra/${nixFile}";
    checkinterval = 1800;
    schedulingshares = 100;
    enableemail = false;
    emailoverride = "";
    keepnr = 3;
    type = 0;  # Non-flake (legacy)
    inputs = {
      src = {
        type = "git";
        value = "git://github.com/nix-community/emacs-overlay.git";
        emailresponsible = false;
      };
      nixpkgs = {
        type = "git";
        value = "git://github.com/NixOS/nixpkgs.git ${nixpkgsRelease}";
        emailresponsible = false;
      };
    };
  };

  jobsets = {

    unstable = mkJobset {
      nixpkgsRelease = "nixos-unstable";
      nixFile = "emacsen.nix";
      descriptionNote = "emacs";
    };

    stable = mkJobset {
      nixpkgsRelease = "nixos-20.09";
      nixFile = "emacsen.nix";
      descriptionNote = "emacs";
    };

    unstable-pkgs = mkJobset {
      nixpkgsRelease = "nixos-unstable";
      nixFile = "packages.nix";
      descriptionNote = "emacs packages";
    };

    unstable-rc-pkgs = mkJobset {
      nixpkgsRelease = "nixos-unstable";
      nixFile = "packages-unstable.nix";
      descriptionNote = "emacs packages (pre-release)";
    };

    unstable-git-pkgs = mkJobset {
      nixpkgsRelease = "nixos-unstable";
      nixFile = "packages-git.nix";
      descriptionNote = "emacs packages (git)";
    };

    unstable-gcc-pkgs = mkJobset {
      nixpkgsRelease = "nixos-unstable";
      nixFile = "packages-gcc.nix";
      descriptionNote = "emacs packages (native-comp)";
    };

  };

in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toXML declInput}
    EOF
    cat > spec.json <<EOF
    ${builtins.toJSON jobsets}
    EOF

    cat spec.json | ${pkgs.jq}/bin/jq -r . > $out

  '';
}
