{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAfter mkDefault;

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
  services.caddy.virtualHosts.domain.extraConfig = mkAfter (handle "/${domain}");

  services.caddy.virtualHosts.openpgpkey = {
    hostName = mkDefault "openpgpkey.${domain}";
    extraConfig = ''
      import common
      import useCloudflare

      ${handle ""}
    '';
  };
}
