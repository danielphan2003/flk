{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.wayland.windowManager.sway.config) menu mod terminal;

  light = cmd: "exec ${pkgs.avizo}/bin/lightctl ${cmd}";
  power = cmd: "exec ${pkgs.nwg-launchers}/bin/nwgbar";
  netMan = cmd: "exec ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu ${cmd}";
  clipMan = cmd: "exec ${pkgs.clipman}/bin/clipman ${cmd}";

  bemenu-run = pkgs.callPackage ../scripts/bemenu-run.nix {};
  screenshare = pkgs.callPackage ../scripts/screenshare.nix {};
  bemenu-screenshare = pkgs.callPackage ../scripts/bemenu-screenshare.nix {inherit bemenu-run screenshare;};
  bemenu-unicode = pkgs.callPackage ../scripts/bemenu-unicode.nix {inherit bemenu-run;};
in {
  imports = lib.flk.getNixFiles ./.;

  services.swhkd.keybindings = {
    "super + enter" = "exec ${terminal}";

    "super + d" = "exec ${menu}";

    # firefox bug, don't mind it
    # "Ctrl+q" = "exec echo";

    # Start network manager
    "super + n" = netMan "-b";

    "super + v" = clipMan ''pick -t CUSTOM --tool-args="${bemenu-run} -l 30 -p Clipboard"'';

    # Reload sway
    "super + shift + c" = "exec swaymsg reload";

    # Exit sway
    "super + shift + e" = "exec swaymsg exit";

    # Lock
    "super + alt + l" = "exec ${pkgs.sway-physlock}/bin/sway-physlock";

    # Power menu
    "ctrl + alt + delete" = power "-o 0.2";

    "super + x" = "${bemenu-screenshare}";
  };
}
