{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  handle = path: ''
    handle_path /.well-known/openpgpkey* {
      templates
      header {
        Content-Type application/octet-stream
        Access-Control-Allow-Origin *
      }
      root * ${./openpgpkey}${path}
      try_files {path} {path}
      file_server
    }
  '';
in {
  services.caddy.virtualHosts."${domain}".extraConfig = lib.mkAfter ''
    ${handle "/${domain}"}
  '';

  services.caddy.virtualHosts."openpgpkey.${domain}".extraConfig = ''
    import common
    import useCloudflare
    ${handle ""}
  '';
}
