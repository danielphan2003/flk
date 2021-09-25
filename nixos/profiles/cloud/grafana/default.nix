{ config, lib, options, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (config.services.grafana) addr port;
  inherit (lib.our.hostConfigs.tailscale) tailnet_alias;
  inherit (lib.our.hostConfigs.hosts."${hostName}") tailscale_ip;

  tailnet-domain = "${hostName}.${tailnet_alias}";
in
{
  services.grafana = {
    enable = true;
    port = 2342;
    addr = tailscale_ip;
  };

  services.caddy.virtualHosts."*.${tailnet-domain}".extraConfig = lib.mkAfter ''
    @grafana host grafana.${tailnet-domain}
    handle @grafana {
      reverse_proxy ${addr}:${toString port}
    }
  '';
}
