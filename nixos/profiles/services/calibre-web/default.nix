{
  config,
  hostConfigs,
  lib,
  ...
}: let
  inherit (config.networking) domain hostName;
  inherit (hostConfigs.hosts."${hostName}") tailscale_ip;
  inherit (config.services.calibre-web.listen) ip port;
in {
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      # ip = tailscale_ip;
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

  services.caddy.virtualHosts."calibre.${domain}".extraConfig = ''
    import common
    import NoSearchHeader
    import useCloudflare
    reverse_proxy ${ip}:${toString port}
  '';
}
