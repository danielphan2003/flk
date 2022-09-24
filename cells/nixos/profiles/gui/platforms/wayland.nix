{
  config,
  lib,
  pkgs,
  profiles,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    profiles.desktop.drivers
    profiles.fonts.minimal
  ];

  # services.cron.systemCronJobs = [
  #   "*/20 * * * *      danie      $HOME/.local/bin/wal-set >> /tmp/wal-set.log"
  # ];

  environment.systemPackages = [pkgs.xdg-desktop-portal pkgs.qt5.qtwayland] ++ config.xdg.portal.extraPortals;

  security.polkit.enable = true;

  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = let
        exec_notify = type: ''${pkgs.libnotify}/bin/notify-send "xdg-desktop-portal-wlr" "Screen sharing ${type}"'';
      in {
        output_name = "HDMI-A-1";
        max_fps = 30;
        exec_before = exec_notify "started";
        exec_after = exec_notify "ended";
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "sway";

        MOZ_ENABLE_WAYLAND = "1";

        # Tell toolkits to use wayland
        CLUTTER_BACKEND = "wayland";
        # needs qt5.qtwayland in systemPackages
        QT_QPA_PLATFORM = "wayland-egl";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ECORE_EVAS_ENGINE = "wayland-egl";
        ELM_ENGINE = "wayland_egl";
        SDL_VIDEODRIVER = "wayland";

        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        _JAVA_AWT_WM_NONREPARENTING = "1";
        NO_AT_BRIDGE = "1";

        # Disable HiDPI scaling for X apps
        # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
        GDK_SCALE = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "0";

        # nixos specific wayland
        NIXOS_OZONE_WL = "1";
      };
    }
  ];
}
