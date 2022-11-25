# unmaintained
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) domain;

  dbConnString = db: "postgresql:///run/postgresql/${db}";

  services = {
    discord = {
      port = 9005;
      listenAddress = "localhost";
      format = "matrix-appservice";
      package = pkgs.matrix-appservice-discord;
      settings = {
        bridge = {
          inherit domain;
          homeserverUrl = "https://${domain}:443";
        };
      };
    };
  };
in {
  services.matrix-appservices = {
    homeserver = "conduit";
    services =
      lib.mapAttrs
      (bridge: bridgeOpts:
        bridgeOpts
        // {
          settings.database.connString = dbConnString "matrix-${bridge}";
        })
      services;
  };

  services.postgresql = {
    ensureDatabases = map (bridge: "matrix-${bridge}") (builtins.attrNames services);
    ensureUsers =
      lib.mapAttrsToList
      (bridge: bridgeOpts: {
        name = "matrix-as-${bridge}";
        ensurePermissions = {
          "DATABASE matrix-${bridge}" = "ALL PRIVILEGES";
        };
      })
      services;
  };
}
