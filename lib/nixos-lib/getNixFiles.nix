{ lib }:
folder:
let
  toImport = name: type: folder + ("/" + name);
  filterNixFiles = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  nixFiles = lib.mapAttrsToList toImport (lib.filterAttrs filterNixFiles (builtins.readDir folder));
in
nixFiles
