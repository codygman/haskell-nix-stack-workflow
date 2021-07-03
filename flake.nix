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

          # TODO I need to figure out how to actually use this
          myHaskellPackages = prev.haskell.packages.${compiler}.override {
            overrides = hpFinal: hpPrev: {
              hspec = hpPrev.callHackage "witch" "3.3.0" {};
            };
          };

          # This overlay adds our project to pkgs
          myproj =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc8104";
              # This is used by `nix develop .` to open a shell for use with
              # `cabal`, `hlint` and `haskell-language-server`
              shell.tools = {
                cabal = {};
                hlint = {};
                haskell-language-server = {};
                nonono = {};
              };
              shell.additional = {
                hpack = {};
              };
              # This adds `js-unknown-ghcjs-cabal` to the shell.
              # shell.crossPlatform = p: [p.ghcjs];
            };
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };

      # devShell = haskellNix.shellFor {
      #     packages = p: [ p.smurf ];
      #     withHoogle = false;
      #     tools = {
      #       cabal = {};
      #       haskell-language-server = {};
      #       ghcid = {};
      #     };
      #     nativeBuildInputs = [
      #       # test-repl # Used for writing tests.
      #       hsPkgs.hpack
      #      # haskellNix.too-many-logs.project.roots
      #     ];
      #     exactDeps = true;
      # };

      flake = pkgs.myproj.flake {
        # This adds support for `nix build .#js-unknown-ghcjs-cabal:myproj:exe:myproj`
        # crossPlatforms = p: [p.ghcjs];
      };
    in flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."myproj:exe:myproj-exe";
    });
}
