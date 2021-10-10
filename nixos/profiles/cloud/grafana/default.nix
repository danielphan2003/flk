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
    addr = "127.0.0.1";
    domain = tailnet-domain;
    rootUrl = "%(protocol)s://%(domain)s:%(http_port)s/grafana/";
    extraOptions = {
      SERVER_SERVE_FROM_SUB_PATH = "true";
    };
  };

  services.caddy.virtualHosts."${tailnet-domain}".extraConfig = lib.mkAfter ''
    reverse_proxy /grafana* ${addr}:${toString port}
  '';
}
