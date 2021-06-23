{ lib }:
{
  getNormalUsers = import ./getNormalUsers.nix;
  mkCustomI3Rule = import ./mkCustomI3Rule.nix { inherit lib; };
  mkFirefoxConfig = import ./mkFirefoxConfig.nix { inherit lib; };
  persistence = import ./persistence { inherit lib; };
  pywal = import ./pywal { inherit lib; };
}