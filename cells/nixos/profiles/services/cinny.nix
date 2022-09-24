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

  templatedCinnyWeb = pkgs.cinny-web.override {inherit conf;};
in {
  services.caddy.virtualHosts.cinny = {
    hostName = lib.mkDefault "cinny.${domain}";
    extraConfig = ''
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
  };
}
