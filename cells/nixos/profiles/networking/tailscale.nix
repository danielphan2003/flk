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

  services.fail2ban.ignoreIP = ["100.64.0.0/16"];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  environment.shellAliases = {
    ts = "tailscale";
    sts = "sudo tailscale";
  };
}
