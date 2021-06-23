{ pkgs, config, lib, ... }:
let
  wal-set = pkgs.callPackage ./config/scripts/wal-set.nix {
    inherit (config.wayland.windowManager.sway.config) colors;
    backgroundDir = "/mnt/danie/Slideshows/Home";
  };
in
{
  imports = [ ./gammastep ./kanshi ./mako ./waybar ];

  qt.platformTheme = "gtk";

  gtk.enable = true;

  services.gpg-agent.pinentryFlavor = "gnome3";

  home.file.".local/bin/wal-set".source = wal-set;

  home.packages = with pkgs; [
    # sway-dependent
    xwayland
    swaylock-effects
    swayidle
    swaybg
    autotiling

    # wayland-dependent
    qt5.qtwayland

    # wm-independent
    dwall-improved
    volnoti
    wmctrl

    # misc
    dmenu
    networkmanager_dmenu
    tdrop
    libappindicator-gtk3
    gtk-layer-shell
  ] ++ (with pkgs.waylandPkgs; [
    clipman
    grim
    lavalauncher
    mako
    nwg-launchers
    slurp
    wdisplays
    wf-recorder
    wl-clipboard
    wlr-randr
    wofi
    wtype
  ]);

  xdg.configFile."nwg-launchers" = {
    source = ./nwg-launchers;
    recursive = true;
  };

  systemd.user.services.volnoti = {
    Unit = {
      Description = "volnoti volume notification";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.volnoti}/bin/volnoti -n";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures = {
      base = true;
      gtk = config.gtk.enable;
    };

    systemdIntegration = true;

    extraConfig = ''
      set $φ 38 ppt
      set $Φ 62 ppt
      seat seat0 xcursor_theme Bibata_Ice 24
      no_focus [app_id="avizo-service"]
      no_focus [app_id="waybar"]

      border_images.focused           ${./shadows.png}
      border_images.focused_inactive  ${./shadows.png}
      border_images.unfocused         ${./shadows.png}
      border_images.urgent            ${./shadows.png}

      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP GTK_IM_MODULE QT_IM_MODULE XMODIFIERS
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

      export CHROME_EXECUTABLE="${pkgs.ungoogled-chromium}/bin/chromium-browser"
    '';
  } // (import ./config { inherit pkgs config lib; });
}
