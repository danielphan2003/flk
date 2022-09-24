{
  lib,
  inputs
}: let
  l = lib;

  inherit
    (l)
    concatMapStringsSep
    foldl'
    head
    id
    isList
    toUpper
    ;
in rec {
  concatComma = concatMapStringsSep "," toString;

  concatMapNewline = concatMapStringsSep "\n";

  concatNewline = concatMapNewline id;

  nameToCamelCase = name: let
    pattern = "_([A-Za-z0-9])";
    parts = builtins.split pattern name;
    partsToCamelCase = parts:
      foldl' (key: x:
        key
        + (
          if isList x
          then toUpper (head x)
          else x
        )) ""
      parts;
  in
    if head parts == name
    then name
    else partsToCamelCase parts;
}
