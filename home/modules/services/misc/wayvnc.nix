{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.wayvnc;
  inherit (cfg) addr configFile maxFps port;
in {
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
        type = types.path;
        default = config.xdg.configFile."wayvnc/config".source;
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
      port = mkOption {
        type = types.int;
        default = 5901;
        description = ''
          Set the port to listen on.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [wayvnc];

    xdg.configFile."wayvnc/config".text = ''
      port=${toString port}
    '';

    systemd.user.services.wayvnc = {
      Unit = {
        Description = "a VNC server for wlroots based Wayland compositors";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Restart = "on-failure";
        ExecStart = ''          ${pkgs.wayvnc}/bin/wayvnc \
                    ${optionalString (configFile != "") "-C ${configFile}"} \
                    -f ${assert asserts.assertMsg (maxFps > 0) "Rate limit for WayVNC must be a positive integer!"; toString maxFps} \
                    ${addr}
        '';
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
