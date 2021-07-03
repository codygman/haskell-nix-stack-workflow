{
  description = "A very basic flake";
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      overlays = [ haskellNix.overlay
        (final: prev: {
          myproj =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc8104";
              shell.tools = {
                cabal = {};
                hlint = {};
                haskell-language-server = {};
              };
            };
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
      flake = pkgs.myproj.flake {};
    in flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."myproj:exe:myproj-exe";
    });
}
