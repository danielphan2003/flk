# unmaintained
{
  lib,
  pkgs,
  profiles,
  ...
}: let
  inherit (config.flk.currentHost) tailscale;

  package = pkgs.dnscrypt-proxy2;
in {
  imports = [profiles.network.dns.common];

  networking.nameservers = lib.mkBefore [tailscale.ip];

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        "dnscrypt-sg-blahdns-ipv4"
        "moulticast-sg-ipv4"
        # "yepdns-sg"
        "dnscrypt-sg-blahdns-ipv6"
        # "moulticast-sg-ipv6"
        "yepdns-sg-ipv6"
      ];

      listen_addresses = ["${tailscale.ip}:53"];

      ipv6_servers = true;

      require_dnssec = true;

      # TODO: build a fancy dns server with 64gb of r-ram, th-threadripper plz.
      # dnscrypt_ephemeral_keys = false;

      bootstrap_resolvers = [
        "9.9.9.9:53"
        "[2620:fe::fe]:53"
      ];

      # this allows rewriting requests like *.beta.tailscale.net to be handled by Tailscale internal dns.
      # however, this only works for fully-qualified domains --> how to resolve partial domains?
      forwarding_rules = pkgs.writeText "forwarding-rules.txt" ''
        facebook.com        208.67.222.222
        facebook.net        208.67.222.222
        fbcdn.net           208.67.222.222
        fbsbx.com           208.67.222.222
        messenger.com       208.67.222.222
      '';

      captive_portals.map_file = "${package.src}/dnscrypt-proxy/example-captive-portals.txt";

      sources = {
        public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            "https://ipv6.download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            "https://download.dnscrypt.net/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
            "https://ipv6.download.dnscrypt.info/resolvers-list/v3/relays.md"
            "https://download.dnscrypt.net/resolvers-list/v3/relays.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };

      anonymized_dns = {
        routes = [
          {
            server_name = "*";
            via = [
              # "anon-tiarap"
              "anon-saldnssg01-conoha-ipv4"
              "anon-tiarap-ipv6"
              "anon-cs-berlin"
              "anon-inconnu"
            ];
          }
        ];
        skip_incompatible = true;
      };
    };
  };
}
