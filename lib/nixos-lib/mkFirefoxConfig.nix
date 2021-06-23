{ lib, ... }:
{ firefoxConfig ? { }, extraConfig ? "" }:
let
  inherit (lib) concatStrings mapAttrsToList;
  inherit (builtins) toJSON;
in
''
  ${extraConfig}

  ${concatStrings (mapAttrsToList
    (name: value: ''
  user_pref("${name}", ${toJSON value});
    '')
  firefoxConfig)}
''
