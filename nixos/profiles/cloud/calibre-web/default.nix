{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) nameserver;
  inherit (config.services.calibre-web.listen) ip port;
in
{
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = "127.0.0.1";
      port = 8083;
    };
    options = {
      calibreLibrary = "/var/lib/calibre-library";
      enableBookUploading = true;
      enableBookConversion = true;
      reverseProxyAuth.enable = true;
    };
  };

  # services.caddy.virtualHosts."calibre.${hostName}" = {
  #   serverAliases = [ "calibre.${nameserver}" ];
  #   extraConfig = ''
  #     reverse_proxy ${ip}:${toString port}
  #   '';
  # };
}
