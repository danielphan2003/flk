{
  self,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config.networking) domain;
  cfg = config.services.caddy;

  virtualHosts = mapAttrsToList (host: hostOpts: [hostOpts.hostName] ++ hostOpts.serverAliases) cfg.virtualHosts;

  subdomainVHosts = filter (x: hasSuffix ".${domain}" x) (flatten virtualHosts) ++ ["matrix.${domain}" "identity.${domain}"];
in {
  age.secrets.caddy = {
    file = "${self}/secrets/nixos/profiles/cloud/caddy.age";
    owner = cfg.user;
    inherit (cfg) group;
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.caddy.path;

  networking.firewall.allowedTCPPorts = [80 443];

  # see https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size
  boot.kernel.sysctl."net.core.rmem_max" = 2500000;

  services.nginx.enable = mkForce false;

  services.caddy = {
    enable = true;
    globalConfig = mkBefore ''
      dynamic_dns {
        provider cloudflare {env.CLOUDFLARE_API_TOKEN}
        domains {
          ${domain} @ ${concatMapStringsSep " " (x: removeSuffix ".${domain}" x) (unique subdomainVHosts)}
        }
        ip_source simple_http https://icanhazip.com
        check_interval 5m
        versions ipv6
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
    virtualHosts."${domain}".extraConfig = ''
      import common
      import useCloudflare
    '';
  };
}
