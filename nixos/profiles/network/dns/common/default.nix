{ lib, config, ... }:
let dnsPort = 53; in
{
  networking.firewall.allowedUDPPorts = [ dnsPort ];
}
