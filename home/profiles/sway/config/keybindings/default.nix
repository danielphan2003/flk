{ pkgs, config, lib, ... }:
let
  inherit (config) menu terminal;
  mod = config.modifier;

  light = cmd: "exec ${pkgs.avizo}/bin/lightctl ${cmd}";
  power = cmd: "exec ${pkgs.waylandPkgs.nwg-launchers}/bin/nwgbar";
  netMan = cmd: "exec ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu ${cmd}";
  clipMan = cmd: "exec ${pkgs.clipman}/bin/clipman ${cmd}";

  bemenu-run = pkgs.callPackage ../scripts/bemenu-run.nix { };
  screenshare = pkgs.callPackage ../scripts/screenshare.nix { };
  bemenu-screenshare = pkgs.callPackage ../scripts/bemenu-screenshare.nix { inherit bemenu-run screenshare; };
  bemenu-unicode = pkgs.callPackage ../scripts/bemenu-unicode.nix { inherit bemenu-run; };
  lock = pkgs.callPackage ../scripts/lock.nix { };
in
{
  keybindings = {
    "${mod}+Return" = "exec ${terminal}";

    "${mod}+d" = "exec ${menu}";

    # firefox bug, don't mind it
    "Ctrl+q" = "exec echo";

    # Start network manager
    "${mod}+n" = netMan "-b";

    "${mod}+v" = clipMan ''pick -t CUSTOM --tool-args="${bemenu-run} -l 30 -p Clipboard"'';

    # Reload sway
    "${mod}+Shift+c" = "reload";

    # Exit sway
    "${mod}+Shift+e" = "exec swaymsg exit";

    # Lock
    "${mod}+Alt+l" = "exec ${lock}";

    # Power menu
    "Ctrl+Alt+Delete" = power "-o 0.2";

    # Control brightness
    XF86MonBrightnessUp = light "raise";
    XF86MonBrightnessDown = light "lower";

    "${mod}+x" = "exec ${bemenu-screenshare}";
  } // (import ./audio.nix { inherit pkgs mod; })
  // (import ./screenshot.nix { inherit pkgs mod; })
  // (import ./windows.nix { inherit mod; })
  // (import ./workspaces.nix { inherit mod lib; });
}
