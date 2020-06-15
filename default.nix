let
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/edc948e0e8dc9b71b22b61ac06be2b4d5f54591d.tar.gz) {};
  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs;

in
{ pkgs ? import nixpkgsSrc nixpkgsArgs
, haskellCompiler ? "ghc883"
}:
pkgs.haskell-nix.stackProject {
  src = pkgs.haskell-nix.haskellLib.cleanGit { name = "myproj"; src = ./.; };
  compiler-nix-name = haskellCompiler;
}
