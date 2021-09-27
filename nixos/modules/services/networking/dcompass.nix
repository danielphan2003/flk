{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.dcompass;
  user = config.users.users.dcompass.name;
  group = config.users.groups.dcompass.name;

  configFile =
    pkgs.writeText "dcompass-config.json" (generators.toJSON { } cfg.settings);
in
{
  options.services.dcompass = {
    enable = mkEnableOption "Dcompass DNS server";

    package = mkOption {
      type = types.package;
      default = pkgs.dcompass.dcompass-maxmind;
      description = "Package of dcompass to use. e.g. pkgs.dcompass.dcompass-cn";
    };

    settings = mkOption {
      type = types.unspecified;
      description = ''
        Configuration file in JSON.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.dcompass = {
      inherit group;
      isSystemUser = true;
    };
    users.groups.dcompass = { };

    environment.etc."dcompass-config.json".source = configFile;

    systemd.services.dcompass = {
      description = "Dcompass DNS service";
      after = [ "network.target" ];
      serviceConfig = {
        User = user;
        Group = group;
        ExecStart = "${cfg.package}/bin/dcompass -c /etc/dcompass-config.json";
        PrivateTmp = "true";
        PrivateDevices = "true";
        ProtectHome = "true";
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
