{
  config,
  lib,
  options,
  pkgs,
  ...
}: {
  fonts.fontDir.enable = true;

  services.cron.systemCronJobs = [
    "*/20 * * * *      danie      $HOME/.local/bin/wal-set >> /tmp/wal-set.log"
  ];

  environment.systemPackages = [pkgs.xdg-desktop-portal] ++ config.xdg.portal.extraPortals;

  programs.hyprland.enable = true;

  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  programs.sway.extraSessionCommands = ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway

    export MOZ_ENABLE_WAYLAND=1

    # Tell toolkits to use wayland
    export CLUTTER_BACKEND=wayland
    export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export SDL_VIDEODRIVER=wayland

    export _JAVA_AWT_WM_NONREPARENTING=1
    export NO_AT_BRIDGE=1

    # Disable HiDPI scaling for X apps
    # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
    export GDK_SCALE=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0

    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export IBUS_DISCARD_PASSWORD_APPS='firefox,.*chrome.*'

    # nixos specific wayland
    export NIXOS_OZONE_WL=1
  '';
}
