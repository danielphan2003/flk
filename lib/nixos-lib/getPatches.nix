{lib}: folder: let
  toImport = name: type: folder + ("/" + name);
  filterPatches = path: type: type == "regular" && lib.hasSuffix ".patch" path;
  patches = lib.mapAttrsToList toImport (lib.filterAttrs filterPatches (builtins.readDir folder));
in
  patches
