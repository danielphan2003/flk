{
  lib,
  inputs,
}: let
  l = lib;

  inherit
    (l)
    all
    any
    cleanSourceWith
    hasSuffix
    mapAttrsToList
    ;
in rec {
  getFiles = {
    exts ? [],
    exceptions ? [],
    src,
  }: let
    files = cleanSourceWith {
      filter = name: type: let
        baseName = baseNameOf (toString name);
        isIncluded = all (exception: baseName != exception) exceptions;
        hasExt = any (ext: hasSuffix ext baseName) exts;
      in
        isIncluded && hasExt;
      inherit src;
    };

    asAbsolutePath = path: _: "${src}/${path}";
  in
    mapAttrsToList asAbsolutePath (builtins.readDir files);

  getNixFiles = src:
    getFiles {
      exts = [".nix"];
      exceptions = ["default.nix"];
      inherit src;
    };

  getPatchFiles = src:
    getFiles {
      exts = [".patch" ".diff"];
      inherit src;
    };
}
