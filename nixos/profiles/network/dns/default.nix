{ config, ... }: {
  networking.nameservers = [ "2620:fe::fe" "2620:fe::9" "9.9.9.9" "149.112.112.112" ];
  services.resolved.fallbackDns = config.networking.nameservers;
}
