{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkBefore mkDefault mkForce;
  inherit (config.networking) domain;

  cfg = config.services.caddy;
in {
  age.secrets.caddy = {
    file = "${self}/secrets/nixos/profiles/cloud/caddy.age";
    owner = cfg.user;
    inherit (cfg) group;
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy.path;

  systemd.services.tailscaled.environment = {
    # configure the Caddy user to have access to Tailscale’s socket
    TS_PERMIT_CERT_UID = cfg.user;
  };

  networking.firewall.allowedTCPPorts = [80 443];

  # experimental HTTP/3
  networking.firewall.allowedUDPPorts = [443];

  services.nginx.enable = mkForce false;

  services.caddy = {
    enable = true;
    email = mkDefault "acme@${domain}";
    # this took me a day to figure out.
    # it will warn with a message:
    # "--config and --resume flags were used together; ignoring --config and resuming from last configuration"
    resume = mkForce false;
    globalConfig = mkBefore ''
      dynamic_dns {
        domains {
          ${domain} @
        }
        dynamic_domains
        check_interval 5m
        provider cloudflare {env.CLOUDFLARE_API_TOKEN}
        ip_source simple_http https://icanhazip.com
        ip_source simple_http https://api64.ipify.org
        versions ipv6
        ttl 1h
      }
      servers :443 {
        protocol {
          experimental_http3
          strict_sni_host
        }
      }
      servers :80 {
        protocol {
          strict_sni_host
        }
      }
    '';
    extraConfig = mkBefore (builtins.readFile ./Caddyfile);
    virtualHosts.domain = {
      hostName = domain;
      extraConfig = mkBefore ''
        import common
        import useCloudflare
      '';
    };
  };
}
