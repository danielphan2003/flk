{ config, lib, self, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (config.services.grafana) addr port;
  inherit (lib.our.hostConfigs.tailscale) nameserver;
in
{
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };

  # services.caddy.virtualHosts."grafana.${hostName}" = {
  #   serverAliases = [ "grafana.${nameserver}" ];
  #   extraConfig = ''
  #     reverse_proxy ${addr}:${toString port}
  #   '';
  # };
}
