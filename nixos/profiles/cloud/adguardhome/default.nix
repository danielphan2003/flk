{ config, lib, ... }: {
  services.adguardhome = {
    enable = true;
    port = 3278;
    host = "0.0.0.0";
    openFirewall = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ config.services.adguardhome.port ];
  };

  networking.nameservers = [ "127.0.0.1" "2a07:a8c0::" ];

  environment.etc."systemd/resolved.conf.d/adguardhome.conf".text = ''
    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no
  '';

  environment.etc."resolv.conf".source = lib.mkForce "/run/systemd/resolve/resolv.conf";
}
