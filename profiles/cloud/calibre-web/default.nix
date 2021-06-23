{ config, ... }:
let persistPath = config.boot.persistence.path; in
{
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = "127.0.0.1";
      port = 8083;
    };
    options = {
      calibreLibrary = "${persistPath}/var/lib/calibre-library";
      enableBookUploading = true;
      enableBookConversion = true;
      reverseProxyAuth.enable = true;
    };
  };
}