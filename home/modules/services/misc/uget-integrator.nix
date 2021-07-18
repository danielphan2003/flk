{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uget-integrator;
  inherit (cfg) chromiumPath mozPath;
in
{
  options = {
    services.uget-integrator = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, start the uget-integrator daemon. Once enabled, uGet will
          be able to download files in browsers.
        '';
      };
      mozPath = mkOption {
        type = types.str;
        default = ".mozilla";
        description = ''
          Custom path where uGet for Firefox native messaging manifest file should be put.
        '';
      };
      chromiumPath = mkOption {
        type = types.str;
        default = ".config/chromium";
        description = ''
          Custom path where uGet for Chromium native messaging manifest file should be put.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ uget uget-integrator ];

    systemd.user.services.uget-integrator = {
      Unit = {
        Description = "Native messaging host to integrate uGet Download Manager with web browsers";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.uget-integrator}/bin/uget-integrator";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    home.file."${mozPath}/native-messaging-hosts/com.ugetdm.firefox.json".source =
      "${pkgs.uget-integrator}/lib/mozilla/native-messaging-hosts/com.ugetdm.firefox.json";

    home.file."${chromiumPath}/NativeMessagingHosts/com.ugetdm.chrome.json".source =
      "${pkgs.uget-integrator}/etc/chromium/native-messaging-hosts/com.ugetdm.chrome.json";
  };
}
