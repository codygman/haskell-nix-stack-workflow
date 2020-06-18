#!/usr/bin/env bash


# run this from nix-shell to see if these libraries I had problems with elsewhere are actually in the ghc pkg db


PackageArray=("esqueleto" "monad-logger" "persistent" "persistent-postgresql" "persistent-template")

for pkg in ${PackageArray[*]}; do
	if ! $(ghc-pkg list | grep -q "$pkg"); then
            echo $pkg
        fi
done
