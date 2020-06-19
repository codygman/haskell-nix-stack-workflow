#! /usr/bin/env nix-shell
#! nix-shell -i bash -p lsof
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/d5291756487d70bc336e33512a9baf9fa1788faf.tar.gz

watch echo "total lorri watches: $(lsof | grep inotify | grep lorri | wc -l)"
