{ config, latestModulesPath, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (config.uwu.tailscale) nameserver;
  inherit (config.services.grafana) addr port;
in
{
  imports = [ "${latestModulesPath}/services/web-servers/caddy/default.nix" ];
  disabledModules = [ "services/web-servers/caddy/default.nix" ];

  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };

  services.caddy.virtualHosts."grafana.${hostName}" = {
    serverAliases = [ "grafana.${nameserver}" ];
    extraConfig = ''
      reverse_proxy ${addr}:${toString port}
    '';
  };
}
