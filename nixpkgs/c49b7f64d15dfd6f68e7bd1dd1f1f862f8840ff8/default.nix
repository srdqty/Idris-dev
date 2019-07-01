{ config ? {}, overlays ? [] }:
  import ../fetch-nixpkgs.nix { inherit config overlays; args = ./args.json; }
