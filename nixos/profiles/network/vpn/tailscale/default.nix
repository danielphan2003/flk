{
  config,
  lib,
  ...
}: let
  cfg = config.services.tailscale;
in {
  networking.firewall.trustedInterfaces = [cfg.interfaceName];

  networking.firewall.checkReversePath = "loose";

  services.tailscale = {
    enable = true;
    port = 41641;
    interfaceName = "tailscale0";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
