---
title: "nixpkgs is a treasure"
date: 2024-05-10T14:07:43-04:00
lastmod: 2024-05-10T14:07:43-04:00
slug: nixpkgs-is-a-treasure
excerpt: "Nix and NixOS continue to be the best way to manage and build software that I've found."
---

Nix and NixOS continue to be the best way to manage and build software that I've found. Every project has a `shell.nix` file in the root where I can define the specific software needed to work on that project along with any necessary environment variables or `$PATH` modifications. I ran into an issue this week though where I needed an "old" version of Go (`1.20`) but the version had already been [removed from `nixpkgs`](https://github.com/NixOS/nixpkgs/tree/2e31c3a7e9825ec1ef087b5db2b801e1a9fb6f3b/pkgs/development/compilers/go). How can I pull in an "unlisted" version into my `shell.nix`?

It's actually pretty straightforward, utilize [`fetchTarball`](https://nixos.org/manual/nix/stable/language/builtins.html?highlight=fetchtarball#builtins-fetchTarball) to pull in `nixpkgs` based on a commit where the version was present sometime in the past. You can mix that `import` in with regular/"current" packages with no issue like so:

```nix
{ pkgs ? import <nixpkgs> {} }:

let oldGo = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/33c51330782cb486764eb598d5907b43dc87b4c2.tar.gz";
    sha256 = "sha256:0nflmpfp3pk704vhlvlgh5vgwl8qciqi18mcpl32k79qjziwmih8";
    }) {};
in 

pkgs.mkShell {
  buildInputs = [
    oldGo.go_1_20
    pkgs.gopls
    pkgs.nodejs_18
  ];
  
  hardeningDisable = [ "fortify" ];

  shellHook = ''
    mkdir -p .go .npm
    export GOPATH=$PWD/.go
    export NODE_PATH=$PWD/.npm
    export NPM_CONFIG_PREFIX=$NODE_PATH
    export PATH=$PWD/.yarn/sdks/typescript/bin:$PWD/.go/bin:$PATH:$NODE_PATH/bin
  '';
}
```

Notice I can reference the "`nixpkgs`" tarball/snapshot, `oldGo`, and pull in the version of Go I need?! `nixpkgs` is such a treasure trove of software, it's absolutely incredible!

