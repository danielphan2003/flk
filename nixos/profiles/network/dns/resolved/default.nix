{ lib, config, ... }:
let inherit (lib) mkDefault; in
{
  networking.nameservers = [
    "9.9.9.9"
    "2620:fe::9"
  ];

  services.resolved = {
    enable = mkDefault true;
    dnssec = mkDefault "true";
    fallbackDns = config.networking.nameservers;
  };
}
