# unmaintained
{
  config,
  lib,
  ...
}: let
  inherit (cfg) host port;

  inherit (config.flk.currentHost) tailscale;

  cfg = config.services.adguardhome;
in {
  networking.nameservers = lib.mkBefore [tailscale.ip];

  services.adguardhome = {
    enable = true;
    host = tailscale.ip;
    port = 3000;
    openFirewall = true;
    settings = {
      schema_version = 14;

      dns = {
        bind_host = tailscale.ip;
        bind_hosts = [tailscale.ip tailscale.ipv6];
        upstream_dns = [
          "https://dns.nextdns.io/dns-query"
          "https://dns.cloudflare.com/dns-query"
          "https://dns10.quad9.net/dns-query"
          "quic://unfiltered.adguard-dns.com"
        ];
        bootstrap_dns = ["9.9.9.9"];
        fastest_addr = true;
        edns_client_subnet = false;
        allowed_clients = ["100.64.0.0/10"];
        trusted_proxies = ["100.64.0.0/10"];
        cache_optimistic = true;
        enable_dnssec = true;
        aaaa_disabled = false;
        handle_ddr = true;
      };

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          name = "AdGuard DNS filter";
        }
        {
          enabled = true;
          url = "https://adaway.org/hosts.txt";
          name = "AdAway Default Blocklist";
        }
      ];

      tls = {
        enabled = true;
        server_name = tailscale.https.fqdn;
        port_https = 0;
        # allowing since we are behind a reverse proxy
        allow_unencrypted_doh = true;
        strict_sni_check = true;
      };

      user_rules = [
        # com.mservice.momotransfer
        "@@||app.adjust.com^"

        # myreadingmanga.info
        "@@||c.disquscdn.com^"
      ];

      clients.persistent =
        (lib.partition (x: x != {}) (lib.mapAttrsToList (host: hostCfg:
          if hostCfg.managed
          then {
            inherit (hostCfg) name tags;
            ids = builtins.attrValues {
              inherit
                (hostCfg.tailscale)
                ip
                ipv6
                ;
              inherit (hostCfg) name;
            };
          }
          else {})
        config.flk.hosts))
        .right;
    };
  };

  services.caddy.virtualHosts.adguardhome = {
    hostName = lib.mkDefault tailscale.https.fqdn;
    extraConfig = ''
      import common

      reverse_proxy ${host}:${toString port}
    '';
  };
}
