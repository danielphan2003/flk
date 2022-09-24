{
  lib,
  inputs,
}: let
  l = lib // cells-lab.x86_64-linux.main.library;
  inherit (inputs) cells-lab self std;
in
  l.mapAttrs (_: l.callFlake "${(std.incl self [(self + /lock)])}/lock") {
    # this is a hack to get the lock file to be followed in our nixpkgs channel
    nixpkgs.locked = inputs.nixpkgs-lock.sourceInfo;
    statix.inputs.nixpkgs = "nixpkgs";
  }
