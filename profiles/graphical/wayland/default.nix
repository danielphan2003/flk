{ lib, options, pkgs, ... }:
let inherit (builtins) attrValues;
in
{

  services.xserver.displayManager.sddm = {
    settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
  };

  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = attrValues {
    inherit (pkgs)
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr;
  };

  security.pam.services.swaylock = { };
}
