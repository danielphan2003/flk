{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./keybindings
    ./base.nix
    ./io.nix
    ./startup.nix
    ./window-commands.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      swayidle
      autotiling
      swayprop
      ;
  };

  services.swhks.systemdTarget = "sway-session.target";

  wayland.windowManager.sway = {
    enable = true;

    # already set system-wide
    package = null;

    # already set system-wide
    # xwayland = false;

    wrapperFeatures = {
      base = true;
      gtk = config.gtk.enable;
    };

    systemdIntegration = true;

    extraConfig = ''
      mode passthrough {
        bindsym Mod4+Pause mode default
      }

      bindsym Mod4+Pause mode passthrough

      set $φ 38 ppt
      set $Φ 62 ppt
      seat seat0 xcursor_theme ${config.home.pointerCursor.name} 24
      no_focus [app_id="avizo-service"]
      no_focus [app_id="waybar"]

      exec dbus-update-activation-environment --systemd \
        DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP \
        GTK_IM_MODULE QT_IM_MODULE XMODIFIERS DBUS_SESSION_BUS_ADDRESS
    '';
  };
}
