{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python3.withPackages(ps: [
    ps.httpx
    ps.lxml
  ]);

in pkgs.mkShell {
  buildInputs = [
    pythonEnv
  ];
}
