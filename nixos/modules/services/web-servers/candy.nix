{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.candy;
in
{
  options.services.candy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use Caddy as the default web server. Candy is just Caddy with candies ;)
      '';
    };
    environmentFile = mkOption {
      type = types.str;
      default = "";
      description = ''
        Path to the environment file for Caddy.
      '';
    };
    config = mkOption {
      type = types.attr;
      default = { };
      description = ''
        Config to pass to services.caddy
      '';
    };
    hosts = mkOption {
      type = types.attrsOf (types.submodule (import ./host-options.nix {
        inherit config lib;
      }));
      default = {
        localhost = { };
      };
      example = literalExample ''
        {
          "hydra.example.com" = {
            location."/" = {
              to = "http://localhost:3000";
            };
          };
        };
      '';
      description = "Declarative vhost config for Caddy";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.candy = {
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = cfg.environmentFile;
      };
      script = ''
        IPV6="$(${pkgs.dnsutils}/bin/dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6 2>&1)"
        ${pkgs.curl}/bin/curl "https://www.candy.org/update?domains=${cfg.domain}&token=${cfg.token}&ipv6=$IPV6&ip="
      '';
    };

    systemd.timers.candy = {
      wantedBy = [ "timers.target" ];
      partOf = [ "duckdns.service" ];
      timerConfig.OnCalendar = "*:0/15";
    };
  };
}
