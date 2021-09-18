{ config, lib, ... }: {
  imports = [ ../common ../disable-resolved ];

  networking.nameservers = [ "127.0.0.1" ];

  services.adguardhome = {
    enable = true;
    port = 3278;
    host = "0.0.0.0";
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.adguardhome.port ];

  # systemd-resolved is the default dns server, but for others to work it needs to be disabled
  services.resolved.enable = false;
}
