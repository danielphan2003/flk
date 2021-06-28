{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.duckdns;
in
{
  options.services.duckdns = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use DuckDNS as the dynamic DNS provider.
      '';
    };
    environmentFile = mkOption {
      type = types.str;
      default = "/run/secrets/duckdns";
      description = ''
        Where the environment file to use for requesting update from DuckDNS.
      '';
    };
    domain = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = ''
        Name of the domain to update. Default to current host name.
        See README for the default config.
      '';
    };
    token = mkOption {
      type = types.str;
      default = "$DUCKDNS_GMAIL";
      description = ''
        Token to request update. Setting this to a variable in environmentFile is
        recommended. Default to $HOSTNAME (uppercase, dash converts to underscore sign).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.duckdns = {
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = cfg.environmentFile;
      };
      script = ''
        IPV6="$(${pkgs.dnsutils}/bin/dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6 2>&1)"
        ${pkgs.curl}/bin/curl "https://www.duckdns.org/update?domains=${cfg.domain}&token=${cfg.token}&ipv6=$IPV6&ip="
      '';
    };

    systemd.timers.duckdns = {
      wantedBy = [ "timers.target" ];
      partOf = [ "duckdns.service" ];
      timerConfig.OnCalendar = "*:0/15";
    };
  };
}
