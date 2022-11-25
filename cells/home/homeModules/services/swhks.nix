{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}:
with lib; let
  cfg = config.services.swhks;

  nixosCfg = nixosConfig.systemd.user.services.swhks;
in {
  options = {
    services.swhks = {
      enable = mkEnableOption nixosCfg.description;

      systemdTarget = mkOption {
        type = types.str;
        default = "default.target";
        description = ''
          Systemd target to bind to.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swhks = {
      Unit = {
        Description = nixosCfg.description;
        PartOf = cfg.systemdTarget;
        Requires = cfg.systemdTarget;
        After = cfg.systemdTarget;
      };

      Service = nixosCfg.serviceConfig;

      Install = {WantedBy = [cfg.systemdTarget];};
    };
  };
}
