{pkgs, ...}: let
  gamecheat = pkgs.callPackage ../../scripts/gamecheat.nix {};
in {
  services.sxhkd.keybindings = {
    "super + g" = "${gamecheat}";
  };
}
