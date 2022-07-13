{...}: {
  gtk.enable = true;

  qt.platformTheme = "gtk";

  services.gpg-agent.pinentryFlavor = "gnome3";
}
