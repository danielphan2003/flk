{ lib, config, ... }: {
  imports = [ ../resolved ];

  networking.firewall.allowedUDPPorts = [ 53 ];

  networking.nameservers = lib.mkDefault config.services.resolved.fallbackDns;
}
