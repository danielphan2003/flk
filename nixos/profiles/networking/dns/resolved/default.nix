{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (config.networking) hostName;

  prio = prio': "${hostName}-187c5e.dns${toString prio'}.nextdns.io";
in {
  networking.nameservers = [
    "2a07:a8c0::#${prio 1}"
    "2a07:a8c1::#${prio 2}"
    "45.90.28.0#${prio 1}"
    "45.90.30.0#${prio 2}"
  ];

  services.resolved = {
    enable = mkDefault true;
    dnssec = mkDefault "allow-downgrade";
    fallbackDns = mkDefault ["9.9.9.9#dns.quad9.net"];
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };
}
