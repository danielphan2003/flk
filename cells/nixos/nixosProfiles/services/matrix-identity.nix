# unmaintained
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;

  inherit (config.services.mxisd) matrix server;

  inherit (config.networking) domain;
in {
  services.mxisd = {
    enable = true;
    matrix.domain = mkDefault "matrix.${domain}";
    server = {
      name = mkDefault "identity.${domain}";
      port = 8090;
    };
  };

  services.caddy.virtualHosts.matrix-identity = {
    hostName = server.name;
    extraConfig = ''
      import common
      import useCloudflare

      reverse_proxy /_matrix/identity 127.0.0.1:${toString server.port} {
        import MatrixWellknownHeaders
        import /var/lib/caddy/templates/cloudflare-proxies
        header_up Host {host}
        header_up X-Forwarded-For {remote_ip}
      }
    '';
  };
}
