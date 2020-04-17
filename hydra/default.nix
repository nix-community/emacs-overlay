{ nixpkgs, declInput }:
let
  pkgs = import nixpkgs {};

  mkJobset = {
    nixpkgsRelease
  }: {
    enabled = 1;
    hidden = false;
    description = "Emacs-overlay jobset for nixpkgs branch ${nixpkgsRelease}";
    nixexprinput = "src";
    nixexprpath = "hydra/release.nix";
    checkinterval = 300;
    schedulingshares = 100;
    enableemail = false;
    emailoverride = "";
    keepnr = 3;
    inputs = {
      src = {
        type = "git";
        value = "git://github.com/nix-community/emacs-overlay.git";
        emailresponsible = false;
      };
      nixpkgs = {
        type = "git";
        value = "git://github.com/NixOS/nixpkgs-channels.git ${nixpkgsRelease}";
        emailresponsible = false;
      };
    };
  };

  jobsets = {
    unstable = mkJobset {
      nixpkgsRelease = "nixos-unstable";
    };
    stable = mkJobset {
      nixpkgsRelease = "nixos-20.03";
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
