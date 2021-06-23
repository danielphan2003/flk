{ lib }:
{
  mkEtcPersist = import ./mkEtcPersist.nix { inherit lib; };
  mkTmpfilesPersist = import ./mkTmpfilesPersist.nix { inherit lib; };
}