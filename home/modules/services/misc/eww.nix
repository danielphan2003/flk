{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.eww;
in
{
  options = {
    services.eww = {
      enable = mkEnableOption ''
        If enabled, start the eww daemon. Once enabled, eww will
        be able to display defined bars.
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ eww ];

    systemd.user.services.eww = {
      Unit = {
        Description = "a bar display";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecPreStart = "${pkgs.coreutils}/bin/mkfifo /tmp/ewwpipe";
        ExecStart = "${pkgs.eww}/bin/eww --no-daemonize daemon";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
