{ lib, options, pkgs, latestModulesPath, ... }: {
  imports = [ "${latestModulesPath}/config/xdg/portals/wlr.nix" ];

  services.xserver.displayManager.sddm = {
    settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
  };

  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "''${pkgs.waylandPkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  security.pam.services.swaylock = { };
}
