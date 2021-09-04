{ lib }:
folder:
let
  toImport = name: value: folder + ("/" + name);
  filterPatches = key: value: value == "regular" && lib.hasSuffix ".patch" key;
  patches = lib.mapAttrsToList toImport (lib.filterAttrs filterPatches (builtins.readDir folder));
in
patches
