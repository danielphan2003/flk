{ config, lib, self, ... }:
let
  inherit (lib.our) hostConfigs;
  inherit (config.networking) hostName;

  # maybe using Tailscale is superior to setting your IP manually...
  ip = hostConfigs.hosts."${hostName}".ip_addr;

  privateConfig =
    let
      dhcpV4Config = {
        # dont enforce me to use your crappy dns servers
        UseDNS = false;
        Anonymize = true;
      };
    in
    {
      DHCP = "yes";

      # (broken) on private networks, use DHCP for IPv6
      # DHCP = "ipv6";
      # use static IPv4 address
      # address = [ "${ip}/24" ];

      networkConfig = {
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        DNS = [
          "100.100.100.100"
          "2a07:a8c0::#${hostName}-187c5e.dns1.nextdns.io"
          "2a07:a8c1::#${hostName}-187c5e.dns2.nextdns.io"
        ];
        Domains = [ hostConfigs.tailscale.nameserver ];
      };

      inherit dhcpV4Config;
      dhcpV6Config = builtins.removeAttrs dhcpV4Config [ "Anonymize" ];
    };

  linkConfig = {
    MACAddressPolicy = "random";
  };

  publicConfig = privateConfig // {
    networkConfig = privateConfig.networkConfig // {
      IPv6PrivacyExtensions = "prefer-public";
    };
  };
in
{
  networking.useNetworkd = true;
  networking.dhcpcd.enable = lib.mkForce false;
  networking.useDHCP = lib.mkForce false;

  systemd.network = {
    enable = true;
    networks = {
      "budstick-home-wired" = privateConfig // {
        name = "eth*";
        # broken
        # addresses = [{ addressConfig.Address = "${ip}/24"; }];
        dhcpV4Config.RouteMetric = 1024; # Better be explicit
      };
      "budstick-home-wireless" = privateConfig // {
        name = "wl*";
        matchConfig.SSID = "Cu Do";
        dhcpV4Config.RouteMetric = 2048; # Prefer wired
      };
      "budstick-public-wireless" = publicConfig // {
        name = "wl*";
        dhcpV4Config.RouteMetric = 2048; # Prefer wired
      };
    };
    links = lib.genAttrs (builtins.attrNames config.systemd.network.networks) (link: { inherit linkConfig; });
  };

  # Wait for any interface to become available, not for all
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];
}
