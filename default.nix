let
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/59cf05606e7efbbc4741ae28fd8cc610cec94eb8.tar.gz) {};
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
