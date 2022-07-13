{
  config,
  hostConfigs,
  lib,
  options,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (config.services.grafana) addr port domain;
  inherit (hostConfigs.hosts."${hostName}") tailscale_ip;
in {
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
    domain = "grafana.${config.networking.domain}";
  };

  services.caddy.virtualHosts."${domain}".extraConfig = ''
    import common
    import NoSearchHeader
    import useCloudflare
    reverse_proxy ${addr}:${toString port}
  '';
}
