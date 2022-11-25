{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.flk.i3wm) assign colorRule;
in {
  wayland.windowManager.sway.config = {
    assigns =
      assign 9 {app_id = "zoom";}
      // assign 10 {class = "Slack";}
      // assign 22 {class = "Spotify";};

    # using systemd to start waybar
    bars = [];

    # fonts = {
    #   names = ["SF Pro Display" "Font Awesome 5 Free Regular 11"];
    #   # A hacky way to load colors from pywal on startup without reloading
    #   style =
    #     "\n"
    #     + ''
    #       include ~/.cache/wal/colors-sway
    #       exec_always ~/.local/bin/wal-set
    #       exec echo'';
    #   size = 11.0;
    # };

    gaps.inner = 25;

    focus.followMouse = false;

    window.border = 1;

    floating.titlebar = true;

    defaultWorkspace = "workspace number 1";

    workspaceLayout = "default";

    menu = "${pkgs.nwg-drawer}/bin/nwg-drawer -ovl";

    modifier = "Mod4";

    terminal = "${pkgs.alacritty}/bin/alacritty";

    # colors = {
    #   focused = colorRule "$color5" "$background" "$color5" "$color5" "$color5";
    #   focusedInactive = colorRule "$color2" "$background" "$foreground" "$color2" "$color2";
    #   unfocused = colorRule "$color2" "$background" "$foreground" "$color2" "$color2";
    #   urgent = colorRule "$foreground" "$background" "$color1" "$foreground" "$foreground";
    # };

    keybindings = {};
  };
}
