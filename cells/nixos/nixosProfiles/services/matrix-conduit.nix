{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkAfter mkDefault;

  inherit (cfg.settings.global) address port server_name;

  inherit (config.networking) domain;

  cfg = config.services.matrix-conduit;

  matrixSubdomain = "matrix.${server_name}";
in {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.matrix-conduit;
    settings = {
      global = {
        address = mkDefault "127.0.0.1";
        port = 6167;
        server_name = mkDefault domain;

        allow_encryption = true;
        allow_federation = true;
        allow_registration = false; # set this to false if this is your first time setting up

        enable_lightning_bolt = false;

        trusted_servers = ["matrix.org" "nixos.org" "libera.chat"];

        database_backend = "rocksdb";
      };
    };
  };

  services.caddy.virtualHosts.domain.extraConfig = let
    server = {
      "m.server" = matrixSubdomain;
    };
    client =
      {
        "m.homeserver" = {
          base_url = "https://${matrixSubdomain}";
        };
      }
      // (lib.optionalAttrs config.services.mxisd.enable {
        "m.identity_server" = {
          base_url = "https://" + (config.services.mxisd.server.name or "identity.${domain}");
        };
      });
  in
    mkAfter ''
      handle /.well-known/matrix/server {
        import MatrixWellknownHeaders
        respond `${builtins.toJSON server}`
      }

      handle /.well-known/matrix/client {
        import MatrixWellknownHeaders
        respond `${builtins.toJSON client}`
      }
    '';

  services.caddy.virtualHosts.matrix = {
    hostName = matrixSubdomain;
    extraConfig = ''
      import common
      import useCloudflare

      reverse_proxy ${address}:${toString port}
    '';
  };
}
