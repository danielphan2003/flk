{ lib }:
{
  getNixFiles = import ./getNixFiles.nix { inherit lib; };
  getNormalUsers = import ./getNormalUsers.nix;
  getPatches = import ./getPatches.nix { inherit lib; };
  mkCustomI3Rule = import ./mkCustomI3Rule.nix { inherit lib; };
  mkFirefoxConfig = import ./mkFirefoxConfig.nix { inherit lib; };
  persistence = import ./persistence { inherit lib; };
  pywal = import ./pywal { inherit lib; };
  waybar = import ./waybar { inherit lib; };
}
