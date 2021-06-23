{ lib, config, ... }:
let inherit (builtins) hashString substring;
in
{

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    ethernet.macAddress = "stable";
    wifi.macAddress = "stable";
  };

  networking.nameservers = [ "2620:fe::fe" "2620:fe::9" "9.9.9.9" "149.112.112.112" ];

  # needed for zfs. 4 random bytes (in hex). Nicer implementation suggested by gytis-ivaskevicius/nixfiles
  networking.hostId = substring 0 8 (hashString "md5" config.networking.hostName);
}
