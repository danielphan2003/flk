{ lib, config, ... }: {
  imports = [ ../resolved ];

  networking.firewall.allowedUDPPorts = [ 53 ];

  networking.nameservers = lib.mkDefault config.services.resolved.fallbackDns;

  # systemd-resolved is the default dns server, but for others to work it needs to be disabled
  services.resolved.enable = false;
}
