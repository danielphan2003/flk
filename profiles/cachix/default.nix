# WARN: this file will get overwritten by $ cachix use <name>
{ pkgs, lib, ... }:
let
  folder = ./.;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in
{
  inherit imports;
  nix.binaryCaches = [ "https://cache.nixos.org/" ];
}
