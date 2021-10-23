{ self
, config
, hostConfigs
, lib
, profiles
, ...
}:

let
  inherit (lib) genAttrs mkForce optionalAttrs optionals remove;
  inherit (builtins) attrNames removeAttrs;

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
      # on private networks, use global DHCP for IPv6
      # static IPv6 is always provided with static IPv4
      DHCP = "ipv6";

      # use static IPv4 address
      address = [ "${ip_addr}/24" ];
      gateway = [ "${gateway}" ];

      networkConfig = {
        DNSSEC =
          if config.services.resolved.dnssec == "true"
          then "yes"
          else "no";
        # DNSOverTLS = "yes";
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
  imports = with profiles.network.dns; [ resolved ];

  networking = {
    useNetworkd = true;
    dhcpcd.enable = mkForce false;
    useDHCP = mkForce false;
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
    links = genAttrs
      (attrNames config.systemd.network.networks)
      (link: { inherit linkConfig; });
  };
}
