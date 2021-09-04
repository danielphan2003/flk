{ lib }:
lib.makeExtensible (self: rec {
  nixos-lib = import ./nixos-lib { inherit lib; };

  pkgs-build = import ./pkgs-build { inherit lib; };

  lists = import ./lists.nix { inherit lib; };

  trivial = import ./trivial.nix { inherit lib; };

  inherit (lists)
    appendString
    ;

  inherit (nixos-lib)
    getNormalUsers
    getPatches
    mkCustomI3Rule
    mkFirefoxConfig
    pywal
    ;

  inherit (pkgs-build)
    mkWaybarModule
    wrapZshFunctions
    ;

  inherit (trivial)
    ifttt
    ;
})
