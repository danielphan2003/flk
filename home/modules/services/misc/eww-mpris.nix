{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.eww-mpris;
  inherit (cfg) package;
in {
  options = {
    services.eww-mpris = {
      enable = mkEnableOption ''
        If enabled, start the eww-mpris daemon. Once enabled, eww will
        be able to see media sessions from playerctl.
      '';
      package = mkOption {
        type = types.package;
        default = pkgs.eww-mpris;
      };
      template = {
        box = mkOption {
          type = with types; nullOr path;
          default = null;
        };
        button = mkOption {
          type = with types; nullOr path;
          default = null;
        };
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [package];

    systemd.user.services.eww-mpris = {
      Unit = {
        Description = "a media session service for eww";
        After = ["eww.service"];
      };

      Service = {
        ExecStart = with cfg.template; "${package}/bin/eww-mpris ${optionalString (box != null) "--box ${box}"} ${optionalString (button != null) "--button ${button}"}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = ["eww.service"];
      };
    };
  };
}
