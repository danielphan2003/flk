{ lib }:
{
  getNormalUsers = import ./getNormalUsers.nix;
  mkCustomI3Rule = import ./mkCustomI3Rule.nix { inherit lib; };
  mkFirefoxConfig = import ./mkFirefoxConfig.nix { inherit lib; };
  mkPersist = import ./mkPersist.nix;
  pywal = import ./pywal { inherit lib; };
}