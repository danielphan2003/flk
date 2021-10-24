{ config, hostConfigs, lib, options, ... }:
let
  inherit (config.services.grafana) addr port;
  inherit (hostConfigs.hosts."${config.networking.hostName}") tailnet_domain tailscale_ip;
in
{
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
    domain = tailnet_domain;
    rootUrl = "%(protocol)s://%(domain)s:%(http_port)s/grafana/";
    extraOptions = {
      SERVER_SERVE_FROM_SUB_PATH = "true";
    };
  };

  services.caddy.virtualHosts."${tailnet_domain}".extraConfig = lib.mkAfter ''
    reverse_proxy /grafana* ${addr}:${toString port}
  '';
}
