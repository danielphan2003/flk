# unmaintained
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  inherit (config.services.grafana) addr port domain;
in {
  services.grafana = {
    enable = true;
    port = 2342;
    addr = mkDefault "127.0.0.1";
    domain = mkDefault "grafana.${config.networking.domain}";
  };

  services.caddy.virtualHosts.grafana = {
    hostName = domain;
    extraConfig = ''
      import common
      import NoSearchHeader
      import useCloudflare
      reverse_proxy ${addr}:${toString port}
    '';
  };
}
