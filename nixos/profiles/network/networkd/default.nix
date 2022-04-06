{
  self,
  config,
  hostConfigs,
  lib,
  profiles,
  ...
}: let
  inherit (lib) mapAttrs mkForce optionalAttrs optionals remove;
  inherit (builtins) attrNames removeAttrs;

  inherit (config.networking) hostName;
  ip_addrs = hostConfigs.hosts."${hostName}".ip_addrs or [];
  gateways = hostConfigs.hosts."${hostName}".gateways or [];

  privateConfig = let
    dhcpV4Config = {
      # dont make me use your crappy dns servers
      UseDNS = false;
      Anonymize = true;
    };
  in {
    # on private networks, use global DHCP for IPv6
    # note that static IPv6 is always provided with static IPv4
    DHCP = "ipv6";

    # use static IPv4 address
    address = ip_addrs;
    gateway = gateways;

    networkConfig = {
      DNSSEC = config.services.resolved.dnssec == "true";
      DNSOverTLS = "opportunistic";
      DNS = config.networking.nameservers;
      # Domains = config.networking.search;
    };

    inherit dhcpV4Config;
    dhcpV6Config = removeAttrs dhcpV4Config ["Anonymize"];
  };

  linkConfig = {
    MACAddressPolicy = "random";
  };

  publicConfig =
    (removeAttrs privateConfig ["DHCP" "address" "gateway"])
    // {
      DHCP = "yes";
      networkConfig =
        privateConfig.networkConfig
        // {
          IPv6PrivacyExtensions = "true";
        };
    };
in {
  imports = with profiles.network.dns; [resolved];

  networking = {
    useNetworkd = true;
    dhcpcd.enable = mkForce false;
    useDHCP = mkForce false;
  };

  systemd.network = {
    enable = true;
    networks =
      {
        "budstick-home-wired" =
          privateConfig
          // {
            name = "enp* eth*";
            dhcpV4Config.RouteMetric = 1024; # Better be explicit
          };
      }
      // (optionalAttrs config.networking.wireless.enable {
        "budstick-home-wireless" =
          privateConfig
          // {
            name = "wlp*";
            matchConfig.SSID = "Cu Do";
            dhcpV4Config.RouteMetric = 2048; # Prefer wired
          };
        "budstick-public-wireless" =
          publicConfig
          // {
            name = "wlp*";
            dhcpV4Config.RouteMetric = 2048; # Prefer wired
          };
      });
    links =
      mapAttrs
      (link: _: {inherit linkConfig;})
      config.systemd.network.networks;
  };

  # Wait for any interface to become available, not for all
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];
}
