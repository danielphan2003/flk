{ lib, options, pkgs, ... }: {
  services.xserver.displayManager.sddm = {
    settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
  };

  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    waylandPkgs.xdg-desktop-portal-wlr
  ];

  security.pam.services.swaylock = { };
}
