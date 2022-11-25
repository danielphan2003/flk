{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.rss-bridge;
in {
  services.rss-bridge = {
    inherit (config.services.caddy) user group;
    enable = true;
    virtualHost = lib.mkDefault "rss-bridge.${config.networking.domain}";
    whitelist = ["Facebook"];
  };

  services.caddy.virtualHosts.rss-bridge = {
    hostName = cfg.virtualHost;
    extraConfig = ''
      import common
      import useCloudflare

      root * ${pkgs.rss-bridge}
      php_fastcgi unix/${config.services.phpfpm.pools.${cfg.pool}.socket} {
        env RSSBRIDGE_DATA ${cfg.dataDir}
      }
      file_server
    '';
  };
}
