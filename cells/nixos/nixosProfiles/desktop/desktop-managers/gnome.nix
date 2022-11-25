{pkgs, ...}: {
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = [pkgs.gnomeExtensions.appindicator];

  services.gnome.gnome-browser-connector.enable = true;

  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];
}
