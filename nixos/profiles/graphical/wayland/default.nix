{ lib, options, pkgs, latestModulesPath, ... }: {
  imports = [ "${latestModulesPath}/config/xdg/portals/wlr.nix" ];

  programs.xwayland.enable = true;

  fonts.fontDir.enable = true;

  services.xserver.displayManager.sddm = {
    settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
  };

  services.cron.systemCronJobs = [
    "*/20 * * * *      danie      $HOME/.local/bin/wal-set >> /tmp/wal-set.log"
  ];

  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  security.pam.services.swaylock = { };
}
