{ config, lib, self, ... }:
let
  inherit (lib) optionalAttrs optionals;
  inherit (lib.our) hostConfigs;
  inherit (config.networking) hostName;
  inherit (hostConfigs.hosts."${hostName}") ip_addr gateway;

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
        Domains = [ hostConfigs.tailscale.nameserver ];
      };

      inherit dhcpV4Config;
      dhcpV6Config = builtins.removeAttrs dhcpV4Config [ "Anonymize" ];
    };

  linkConfig = {
    MACAddressPolicy = "random";
  };

  publicConfig = (builtins.removeAttrs privateConfig [ "DHCP" "address" "gateway" ]) // {
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
    nameservers = [ ]
      ++ optionals config.services.adguardhome.enable [ "127.0.0.1" ]
      ++ optionals config.services.tailscale.enable [ "100.100.100.100" ]
      ++ optionals (!config.services.adguardhome.enable) [ "100.127.203.82" ]
      ++
      [
        "2a07:a8c0::#${hostName}-187c5e.dns1.nextdns.io"
        "2a07:a8c1::#${hostName}-187c5e.dns2.nextdns.io"
      ];
  };

  services.resolved = {
    dnssec = "true";
    fallbackDns = config.networking.nameservers;
    domains = [ hostConfigs.tailscale.nameserver ];
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
    links = lib.genAttrs (builtins.attrNames config.systemd.network.networks) (link: { inherit linkConfig; });
  };

  # Wait for any interface to become available, not for all
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];
}
