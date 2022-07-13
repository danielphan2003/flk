{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.rss-bridge;
in {
  services.rss-bridge = {
    inherit (config.services.caddy) user group;

    enable = true;
    whitelist = ["Facebook"];
  };

  services.caddy.virtualHosts."${cfg.virtualHost}.${config.networking.domain}".extraConfig = ''
    import common
    import useCloudflare

    root * ${pkgs.rss-bridge}
    php_fastcgi unix/${config.services.phpfpm.pools.${cfg.pool}.socket} {
      env RSSBRIDGE_DATA ${cfg.dataDir}
    }
    file_server

    # php_fastcgi unix/${config.services.phpfpm.pools.${cfg.pool}.socket} {
    #   root ${pkgs.rss-bridge}
    #   split ^(.+\.php)(/.+)$
    #   env SCRIPT_FILENAME ${pkgs.rss-bridge}/index.php
    #   env RSSBRIDGE_DATA ${cfg.dataDir}
    # }
  '';
}
