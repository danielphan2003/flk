{
  config,
  lib,
  ...
}: let
  inherit (config.services.mxisd) matrix server;
  inherit (config.services.matrix-conduit.settings.global) server_name;
in {
  services.mxisd = {
    enable = true;
    matrix.domain = "matrix.${server_name}";
    server = {
      name = "identity.${server_name}";
      port = 8090;
    };
  };

  services.caddy.virtualHosts."${matrix.domain}".extraConfig = lib.mkAfter ''
    @identity {
      path /_matrix/identity/*
    }

    reverse_proxy /_matrix/identity 127.0.0.1:${toString server.port} {
      import MatrixWellknownHeaders
      import /var/lib/caddy/templates/cloudflare-proxies

      header_up Host {host}
      header_up X-Forwarded-For {remote_ip}
    }
  '';

  services.caddy.virtualHosts."${server.name}".extraConfig = ''
    import common
    import useCloudflare

    reverse_proxy /_matrix/identity 127.0.0.1:${toString server.port} {
      import MatrixWellknownHeaders
      import /var/lib/caddy/templates/cloudflare-proxies
      header_up Host {host}
      header_up X-Forwarded-For {remote_ip}
    }
  '';
}
