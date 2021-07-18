{ pkgs, config, lib, ... }:
let inherit (lib.our.mkCustomI3Rule) assign colorRule; in
{
  config = {

    assigns =
      assign 9 { app_id = "zoom"; } //
        assign 10 { class = "Slack"; } //
        assign 22 { class = "Spotify"; };

    # using systemd to start waybar
    bars = [{ command = "exit"; statusCommand = "exit"; }];

    fonts = {
      names = [ "SF Pro Display" "Font Awesome 5 Free Regular 11" ];
      # A hacky way to load colors from pywal on startup without reloading
      style = "\n" + ''
        exec_always $HOME/.local/bin/wal-set
        include $HOME/.cache/wal/colors-sway
        exec echo'';
      size = 11.0;
    };

    gaps.inner = 25;

    focus.followMouse = false;

    window.borders = 0;

    defaultWorkspace = "workspace number 1";

    workspaceLayout = "default";

    menu = "${pkgs.rofi}/bin/rofi -show drun -theme ${../rofi/appmenu/rofi.rasi}";

    modifier = "Mod4";

    terminal = "${pkgs.alacritty}/bin/alacritty";

    colors = {
      focused = colorRule "$color5" "$background" "$color5" "$color5" "$color5";
      focusedInactive = colorRule "$color2" "$background" "$foreground" "$color2" "$color2";
      unfocused = colorRule "$color2" "$background" "$foreground" "$color2" "$color2";
      urgent = colorRule "$foreground" "$background" "$color1" "$foreground" "$foreground";
    };

  } // (import ./keybindings { inherit pkgs lib; inherit (config.wayland.windowManager.sway) config; })
  // (import ./io.nix { })
  // (import ./startup.nix { inherit pkgs; })
  // (import ./windowCommands.nix { inherit lib; });
}
