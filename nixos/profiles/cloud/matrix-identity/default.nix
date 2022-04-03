{config, ...}: let
  inherit (config.networking) domain;
  inherit (config.services.mxisd.server) name port;
in {
  services.mxisd = {
    enable = true;
    matrix.domain = domain;
    server = {
      name = "identity.${domain}";
      port = 8090;
    };
  };

  services.caddy.virtualHosts."${name}".extraConfig = ''
    import common
    import useCloudflare
    reverse_proxy 127.0.0.1:${toString port}
  '';
}
