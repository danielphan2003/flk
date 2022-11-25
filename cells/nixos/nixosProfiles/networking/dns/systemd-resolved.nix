{
  lib,
  config,
  ...
}: let
  inherit (lib) mkBefore mkDefault;
  inherit (config.networking) hostName;
in {
  networking.nameservers = mkBefore [
    "2a07:a8c1::18:7c5e"
    "2a07:a8c0::18:7c5e"
    "9.9.9.9"
    # "2a07:a8c0::#${prio 1}"
    # "2a07:a8c1::#${prio 2}"
    # "45.90.28.0#${prio 1}"
    # "45.90.30.0#${prio 2}"
  ];

  services.resolved = {
    enable = true;
    dnssec = mkDefault "true";
    fallbackDns = mkBefore ["9.9.9.9" "1.1.1.1"];
    # extraConfig = ''
    #   DNSOverTLS=opportunistic
    # '';
  };
}
