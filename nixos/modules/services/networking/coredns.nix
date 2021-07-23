{ lib, config, ... }:

with lib;

let
  inherit (lib) mkDefault;
  cfg = config.within.coredns;
in
{
  options.within.coredns = {
    enable =
      mkEnableOption "Enables coreDNS for ad-blocking DNS and DNS in general";
    addServer = mkEnableOption "Add this server to the nameserver list";
    addr = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "10.77.2.8";
    };
    prometheus = {
      enable = mkEnableOption "Add prometheus monitoring";
      port = mkOption {
        type = types.port;
        default = 47824;
      };
    };
  };

  config = mkIf cfg.enable {
    services.coredns = {
      enable = true;

      config =
        let
          prom =
            if cfg.prometheus.enable then
              "prometheus ${cfg.addr}:${toString cfg.prometheus.port}"
            else
              "";
        in
        mkDefault ''
          . {
            bind ${cfg.addr}
            ${prom}
            forward . 9.9.9.9 149.112.112.112
            cache
          }
          localhost {
            bind ${cfg.addr}
            ${prom}
            template IN A  {
              answer "{{ .Name }} 0 IN A 127.0.0.1"
            }
          }
        '';
    };

    networking = mkIf cfg.addServer { nameservers = [ cfg.addr ]; };
  };
}
