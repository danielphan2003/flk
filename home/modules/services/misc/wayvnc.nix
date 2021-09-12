{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wayvnc;
  inherit (cfg) addr configFile maxFps;
in
{
  options = {
    services.wayvnc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, start the wayvnc daemon. Once enabled, uGet will
          be able to download files in browsers.
        '';
      };
      addr = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Which address should wayvnc listen to.
        '';
      };
      configFile = mkOption {
        type = types.str;
        default = "~/.config/wayvnc/config";
        description = ''
          Custom path where wayvnc should look for its config.
        '';
      };
      maxFps = mkOption {
        type = types.int;
        default = 30;
        description = ''
          Set the rate limit.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ waylandPkgs.wayvnc ];

    systemd.user.services.wayvnc = {
      Unit = {
        Description = "a VNC server for wlroots based Wayland compositors";
        After = [ "graphical-session-pre.target" "sway-session.target" ];
        PartOf = [ "graphical-session.target" "sway-session.target" ];
      };

      Service = {
        Restart = "on-failure";
        ExecStart = ''${pkgs.waylandPkgs.wayvnc}/bin/wayvnc \
          ${optionalString (configFile != "") "-C ${configFile}"} \
          -f ${assert asserts.assertMsg (maxFps > 0) "Rate limit for WayVNC must be a positive integer!"; toString maxFps} \
          ${addr}
        '';
      };

      Install = {
        WantedBy = [ "graphical-session.target" "sway-session.target" ];
      };
    };
  };
}
