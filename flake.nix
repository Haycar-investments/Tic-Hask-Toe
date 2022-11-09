# Reference: https://input-output-hk.github.io/haskell.nix/
{
  description = "TicHaskToe";
  inputs = {
      haskellNix.url = "github:input-output-hk/haskell.nix";
      nixpkgs.follows = "haskellNix/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
    };
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          haskellNix.overlay
          (final: _: {
            thtProject =
              final.haskell-nix.project' {
                src = ./.;
                compiler-nix-name = "ghc8107";
                shell.tools = {
                    cabal = {};
                    hlint = "3.4.1";
                    haskell-language-server = {};
                };
                shell.buildInputs = [
                ];
                shell.shellHook = ''
                '';
              };
            })
          ];
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
          };
        flake = pkgs.thtProject.flake {
         };
      in
      flake // {
        packages.default = flake.packages."TicHaskToe:exe:TicHaskToe";
      });
}