{ lib }:
lib.makeExtensible (self: rec {
  nixos-lib = import ./nixos-lib { inherit lib; };

  pkgs-build = import ./pkgs-build { inherit lib; };

  inherit (nixos-lib)
    getNormalUsers
    mkCustomI3Rule
    mkFirefoxConfig
    mkPersist
    pywal
  ;

  inherit (pkgs-build)
    mkWaybarModule
    wrapZshFunctions
  ;
})
