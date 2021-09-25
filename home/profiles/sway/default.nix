{ pkgs, config, lib, ... }:
let
  inherit (lib) attrValues;
  wal-set = pkgs.callPackage ./config/scripts/wal-set.nix {
    inherit (config.wayland.windowManager.sway.config) colors;
    backgroundDir = "/mnt/danie/Slideshows/Home";
  };
in
{
  imports = [
    ./gammastep
    ./kanshi
    ./mako
    ./nwg-launchers
    ./waybar
  ];

  qt.platformTheme = "gtk";

  gtk.enable = true;

  services.gpg-agent.pinentryFlavor = "gnome3";

  home.packages = attrValues ({
    inherit (pkgs)
      # sway-dependent
      xwayland
      swaylock-effects
      swayidle
      autotiling

      # wm-independent
      avizo
      flameshot
      nwg-drawer
      nwg-menu
      nwg-panel
      nwg-wrapper
      paper
      wmctrl
      wlrctl

      # misc
      dmenu
      networkmanager_dmenu
      tdrop
      libappindicator-gtk3
      gtk-layer-shell
      ;

    inherit (pkgs.qt5)
      # wayland-dependent
      qtwayland
      ;

    inherit (pkgs)
      clipman
      grim
      mako
      nwg-launchers
      slurp
      swaybg
      wdisplays
      wf-recorder
      wl-clipboard
      wlvncc
      wlr-randr
      wofi
      wtype
      ;
  }
  //
  (lib.optionalAttrs
    (builtins.elem pkgs.system pkgs.lavalauncher.meta.platforms)
    { inherit (pkgs) lavalauncher; }
  ));

  services.avizo.enable = true;

  services.wayvnc = {
    enable = true;
    configFile = "/run/secrets/wayvnc/config";
    maxFps = 60;
  };

  wayland.windowManager.sway = {
    enable = true;

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
      seat seat0 xcursor_theme Bibata_Ice 24
      no_focus [app_id="avizo-service"]
      no_focus [app_id="waybar"]

      border_images.focused           ${./shadows.png}
      border_images.focused_inactive  ${./shadows.png}
      border_images.unfocused         ${./shadows.png}
      border_images.urgent            ${./shadows.png}

      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP GTK_IM_MODULE QT_IM_MODULE XMODIFIERS DBUS_SESSION_BUS_ADDRESS
    '';

    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway

      export MOZ_ENABLE_WAYLAND=1

      # Tell toolkits to use wayland
      export CLUTTER_BACKEND=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_QPA_PLATFORMTHEME=qt5ct
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
    '';

    config = import ./config { inherit pkgs config lib; };
  };

  home.file.".local/bin/wal-set".source = wal-set;
}
