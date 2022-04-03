{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  conf = {
    defaultHomeserver = 0;
    homeserverList = [domain];
  };
  templatedCinnyWeb = pkgs.cinny.override {inherit conf;};
in {
  services.caddy.virtualHosts."cinny.${domain}".extraConfig = ''
    import common
    import useCloudflare
    handle {
      templates
      root * ${templatedCinnyWeb}
      try_files {path} {path}
      try_files {path} /index.html
      file_server
    }
  '';
}
