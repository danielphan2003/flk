{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;
  inherit (config.services.matrix-conduit.settings.global) address port server_name;

  clientPort = port;
  serverPort = 443;
  matrixSubdomain = "matrix.${server_name}";

  rawUpstream = address;
  isIPv6 = ip: builtins.length (lib.splitString ":" ip) > 2;
  upstream =
    if (isIPv6 rawUpstream)
    then "[${rawUpstream}]"
    else rawUpstream;
in {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      conduit-toolbox
      ;
  };

  services.matrix-conduit = {
    enable = true;
    package = pkgs.matrix-conduit;
    settings = {
      global = {
        address = "127.0.0.1";
        allow_encryption = true;
        allow_federation = true;
        allow_registration = true; # set this to false if this is your first time setting up
        port = 6167;
        server_name = domain;
        database_backend = "rocksdb";
        trusted_servers = ["matrix.org" "nixos.org" "libera.chat"];
      };
    };
  };

  services.caddy.virtualHosts."${server_name}".extraConfig = let
    server = {
      "m.server" = "${matrixSubdomain}:${toString serverPort}";
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
    lib.mkAfter
    ''
      handle /.well-known/matrix/server {
        import matrix-well-known-header
        respond `${builtins.toJSON server}`
      }

      handle /.well-known/matrix/client {
        import matrix-well-known-header
        respond `${builtins.toJSON client}`
      }
    '';

  services.caddy.virtualHosts."${matrixSubdomain}".extraConfig = ''
    import common
    import useCloudflare
    reverse_proxy ${upstream}:${toString clientPort}
  '';
}
