{ pkgs, ... }: {
  environment.pathsToLink = [ "/libexec" ];

  environment.sessionVariables = {
    # Theme settings
    QT_QPA_PLATFORMTHEME = "gtk3";

    # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load
    # SVG files (important for icons)
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.xbanish.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ bamboo uniemoji ];
  };

  programs.gnupg.agent.pinentryFlavor = "gnome3";
}
