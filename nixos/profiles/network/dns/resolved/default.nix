{ lib, config, ... }:
let inherit (lib) mkAfter mkDefault; in
{
  networking.nameservers = mkAfter [
    "2a07:a8c0::18:7c5e"
    "2a07:a8c1::18:7c5e"
    "45.90.28.210"
    "45.90.30.210"
  ];

  services.resolved = {
    enable = mkDefault true;
    dnssec = mkDefault "true";
    fallbackDns = config.networking.nameservers;
  };
}
