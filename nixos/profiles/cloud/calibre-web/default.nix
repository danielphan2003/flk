{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) tailnet_alias;
  inherit (lib.our.hostConfigs.hosts."${hostName}") tailscale_ip;
  inherit (config.services.calibre-web.listen) ip port;

  tailnet-domain = "${hostName}.${tailnet_alias}";
in
{
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = tailscale_ip;
      port = 8083;
    };
    options = {
      calibreLibrary = "/var/lib/calibre-library";
      enableBookUploading = true;
      enableBookConversion = true;
      reverseProxyAuth.enable = true;
    };
  };

  services.caddy.virtualHosts."${tailnet-domain}".extraConfig = lib.mkAfter ''
    reverse_proxy /calibre* ${ip}:${toString port}
  '';
}
