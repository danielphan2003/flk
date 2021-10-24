{ config, hostConfigs, lib, ... }:
let
  inherit (config.networking) hostName;
  inherit (hostConfigs.hosts."${hostName}") tailnet_domain tailscale_ip;
  inherit (config.services.calibre-web.listen) ip port;
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

  services.caddy.virtualHosts."${tailnet_domain}".extraConfig = lib.mkAfter ''
    reverse_proxy /calibre* ${ip}:${toString port}
  '';
}
