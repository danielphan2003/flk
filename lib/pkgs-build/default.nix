{ lib }:
{
  mkWaybarModule = import ./mkWaybarModule.nix;
  wrapZshFunctions = import ./wrapZshFunctions.nix { inherit lib; };
}