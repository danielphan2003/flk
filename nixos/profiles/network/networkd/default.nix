{ config, lib, self, ... }:
let
  inherit (lib) genAttrs optionalAttrs optionals remove;
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
  networking = {
    useNetworkd = true;
    dhcpcd.enable = lib.mkForce false;
    useDHCP = lib.mkForce false;
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
    }) // (optionalAttrs config.services.tailscale.enable {
      "${config.services.tailscale.interfaceName}" =
        let
          # see https://github.com/tailscale/tailscale/issues/2697
          RouteMetric = 1000;
        in
        rec {
          dhcpV4Config = { inherit RouteMetric; };
          dhcpV6Config = dhcpV4Config;
        };
    });
    links = genAttrs
      (remove
        "${config.services.tailscale.interfaceName}"
        (attrNames config.systemd.network.networks))
      (link: { inherit linkConfig; });
  };
}
