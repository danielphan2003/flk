{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.eww-mpris;
in
{
  options = {
    services.eww-mpris = {
      enable = mkEnableOption ''
        If enabled, start the eww-mpris daemon. Once enabled, eww will
        be able to see media sessions from playerctl.
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ eww-mpris ];

    systemd.user.services.eww-mpris = {
      Unit = {
        Description = "a media session service for eww";
        After = [ "eww.service" ];
      };

      Service = {
        ExecStart = ''${pkgs.eww-mpris}/bin/eww-mpris'';
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "eww.service" ];
      };
    };
  };
}
