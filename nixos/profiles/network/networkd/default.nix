{ config, lib, self, ... }:
let
  inherit (lib) optionalAttrs optionals;
  inherit (builtins) attrNames removeAttrs;

  inherit (lib.our) hostConfigs;
  inherit (config.networking) hostName;
  inherit (hostConfigs.hosts."${hostName}") ip_addr gateway;

  # TODO: automatically detect when a local dns server (other than Adguard Home) is running.
  enableAdguardHome = config.services.adguardhome.enable;
  enableTailscale = config.services.tailscale.enable;

  privateConfig =
    let
      dhcpV4Config = {
        # dont enforce me to use your crappy dns servers
        UseDNS = false;
        Anonymize = true;
      };
    in
    {
      # on private networks, use DHCP for IPv6
      DHCP = "ipv6";

      # use static IPv4 address
      address = [ "${ip_addr}/24" ];
      gateway = [ "${gateway}" ];

      networkConfig = {
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        DNS = config.networking.nameservers;
        Domains = config.networking.search;
      };

      inherit dhcpV4Config;
      dhcpV6Config = removeAttrs dhcpV4Config [ "Anonymize" ];
    };

  linkConfig = {
    MACAddressPolicy = "random";
  };

  publicConfig = (removeAttrs privateConfig [ "DHCP" "address" "gateway" ]) // {
    DHCP = "yes";
    networkConfig = privateConfig.networkConfig // {
      IPv6PrivacyExtensions = "prefer-public";
    };
  };
in
{
  services.resolved = {
    dnssec = "true";
    fallbackDns = [
      # fallback to NextDNS - at least this still has my adblock rules
      "2a07:a8c0::#${hostName}-77181b.dns1.nextdns.io"
      # last resort
      "9.9.9.9"
    ];
  };

  networking = {
    useNetworkd = true;
    dhcpcd.enable = lib.mkForce false;
    useDHCP = lib.mkForce false;
    nameservers = [ ]
      # if already using Adguard Home
      ++ optionals enableAdguardHome [ "127.0.0.1" ]

      # for Tailscale clients, except those using Adguard Home since they are using their own DNS
      ++ optionals (!enableAdguardHome && enableTailscale) [ "100.100.100.100" ]

      # just to be extra caution ;)
      ++ config.services.resolved.fallbackDns;
  };

  systemd.network = {
    enable = true;
    networks = {
      "budstick-home-wired" = privateConfig // {
        name = "en* eth*";
        dhcpV4Config.RouteMetric = 1024; # Better be explicit
      };
    } // (optionalAttrs config.networking.wireless.enable {
      "budstick-home-wireless" = privateConfig // {
        name = "wlan0";
        matchConfig.SSID = ''"Cu Do"'';
        dhcpV4Config.RouteMetric = 2048; # Prefer wired
      };
      "budstick-public-wireless" = publicConfig // {
        name = "wlan0";
        dhcpV4Config.RouteMetric = 2048; # Prefer wired
      };
    });
    links = lib.genAttrs (attrNames config.systemd.network.networks) (link: { inherit linkConfig; });
  };
}
