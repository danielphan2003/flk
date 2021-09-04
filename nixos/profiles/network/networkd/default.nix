{ config, lib, ... }:
let
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

      networkConfig = {
        # use static IPv4 address
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        DNS = [ "2620:fe::fe" "2620:fe::9" "9.9.9.9" "149.112.112.112" ];
      };

      inherit dhcpV4Config;
      dhcpV6Config = builtins.removeAttrs dhcpV4Config [ "Anonymize" ];
    };

  linkConfig = {
    MACAddressPolicy = "random";
  };

  publicConfig = privateConfig // {
    # let no one knows my exact IP
    DHCP = "yes";
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
        gateway = [ "192.168.1.1" ];
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
