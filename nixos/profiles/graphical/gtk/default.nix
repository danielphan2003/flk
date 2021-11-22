{ pkgs, ... }: {
  environment.pathsToLink = [ "/libexec" ];

  environment.sessionVariables = {
    # Theme settings
    QT_QPA_PLATFORMTHEME = "gtk3";

    # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load
    # SVG files (important for icons)
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = builtins.attrValues {
      inherit (pkgs) xdg-desktop-portal-gtk xdg-desktop-portal-wlr;
    };
  };

  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.xbanish.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = builtins.attrValues {
      inherit (pkgs.ibus-engines) bamboo uniemoji;
    };
  };

  environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];

  services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  programs.gnupg.agent.pinentryFlavor = "gnome3";
}
