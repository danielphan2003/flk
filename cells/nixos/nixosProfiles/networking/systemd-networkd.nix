{
  config,
  lib,
  profiles,
  ...
}:
with lib; {
  imports = [profiles.networking.dns.systemd-resolved];

  networking = {
    useNetworkd = true;
    dhcpcd.enable = mkForce false;
    useDHCP = mkForce false;
  };

  systemd.network = {
    enable = true;
    networks = {
      "40-wired" = {
        enable = true;
        name = "en*";
        networkConfig = {
          DHCP = "yes";
          DNSSEC = "yes";
          DNSOverTLS = "opportunistic";
          DNS = [
            "2a07:a8c0::#187c5e.dns1.nextdns.io"
            "2a07:a8c1::#187c5e.dns2.nextdns.io"
            "9.9.9.9"
          ];
        };
        dhcpV4Config.RouteMetric = 1024;
      };
    };
  };

  # Wait for any interface to become available, not for all
  systemd.services.systemd-networkd-wait-online.enable = false;
  # .serviceConfig.ExecStart = [
  #   ""
  #   "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  # ];
}
