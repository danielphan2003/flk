{pkgs, ...}: let
  gamecheat = pkgs.callPackage ../scripts/gamecheat.nix {};
in {
  services.swhkd.keybindings = {
    "super + g" = "exec ${gamecheat}";
  };
}
