{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib;
  inherit (inputs) nixlib nixpkgs;
in
  l.mapAttrs (name: f: f "${name}.patch") {
    bootspec-rfc = name: nixpkgs.fetchurl {
      inherit name;
      url = "https://github.com/NixOS/nixpkgs/pull/172237.patch";
    };
  }
