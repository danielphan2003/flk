{ config, lib, ... }: {
  imports = [ ../common ];

  networking.nameservers = [ "127.0.0.1" ];

  services.adguardhome = {
    enable = true;
    port = 3278;
    host = "0.0.0.0";
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ config.services.adguardhome.port ];
}
