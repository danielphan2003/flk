{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) attrValues;
  wal-set = pkgs.callPackage ./config/scripts/wal-set.nix {
    inherit (config.wayland.windowManager.sway.config) colors;
    backgroundDir = "/mnt/${config.home.username}/Slideshows/Home";
  };
in {
  imports = [
    ./gammastep
    ./kanshi
    ./mako
    ./nwg-launchers
    ./waybar
  ];

  fonts.fontconfig.enable = true;

  qt.platformTheme = "gtk";

  gtk.enable = true;

  services.gpg-agent.pinentryFlavor = "gnome3";

  services.eww.package = pkgs.eww-wayland;

  home.packages = attrValues ({
      inherit
        (pkgs)
        # sway-dependent
        
        swaylock-effects
        swayidle
        autotiling
        swayprop
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

      inherit
        (pkgs.qt5)
        # wayland-dependent
        
        qtwayland
        ;

      inherit
        (pkgs)
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
    // (
      lib.optionalAttrs
      (builtins.elem pkgs.system pkgs.lavalauncher.meta.platforms)
      {inherit (pkgs) lavalauncher;}
    ));

  services.avizo.enable = true;

  services.wayvnc = {
    enable = true;
    maxFps = 60;
  };

  wayland.windowManager.sway = {
    enable = true;

    # already set system-wide
    package = null;

    # already set system-wide
    xwayland = false;

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


      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP GTK_IM_MODULE QT_IM_MODULE XMODIFIERS DBUS_SESSION_BUS_ADDRESS
    '';

    config = import ./config {inherit pkgs config lib;};
  };

  home.file.".local/bin/wal-set".source = wal-set;
}
