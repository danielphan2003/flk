# unmaintained
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;

  inherit (config.services.calibre-web.listen) ip port;
in {
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = mkDefault "127.0.0.1";
      port = 8083;
    };
    options = {
      calibreLibrary = "/var/lib/calibre-library";
      enableBookUploading = true;
      enableBookConversion = true;
      reverseProxyAuth.enable = true;
    };
  };

  services.caddy.virtualHosts.calibre-web = {
    hostName = mkDefault "calibre.${config.networking.domain}";
    extraConfig = ''
      import common
      import useCloudflare
      import NoSearchHeader

      reverse_proxy ${ip}:${toString port}
    '';
  };
}
