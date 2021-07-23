{ config, ... }:
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
}
