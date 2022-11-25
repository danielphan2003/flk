{
  self,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;

  inherit (cfg.settings) allowed_hosts global;

  cfg = config.services.etebase-server;

  dbCfg = cfg.settings.database;

  runDir = "/run/etebase-server";
in {
  age.secrets.etebase-server-secret-txt = {
    file = "${self}/secrets/nixos/profiles/cloud/etebase-server/secret.txt.age";
    owner = dbCfg.user;
    group = dbCfg.user;
  };

  systemd.tmpfiles.rules = [
    "d '${runDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
  ];

  services.etebase-server = {
    enable = true;
    unixSocket = "${runDir}/etebase-server.sock";
    dataDir = "/var/lib/etebase-server";
    settings = {
      global = {
        secret_file = config.age.secrets.etebase-server-secret-txt.path;
      };
      allowed_hosts.allowed_hosts1 = mkDefault "sync.${config.networking.domain}";
      database = {
        name = "etebase-server";
        host = "/run/postgresql";
        user = cfg.user;
        engine = "django.db.backends.postgresql";
      };
    };
  };

  services.postgresql = {
    ensureDatabases = [dbCfg.name];
    ensureUsers = [
      {
        name = dbCfg.user;
        ensurePermissions = {
          "DATABASE \"${dbCfg.name}\"" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.caddy.virtualHosts.etebase-server = {
    hostName = "${allowed_hosts.allowed_hosts1}";
    extraConfig = ''
      import common
      import useCloudflare

      handle_path /static {
        root * ${global.static_root}
        file_server
      }

      handle_path /user-media {
        root * ${global.media_root}
        file_server
      }

      reverse_proxy unix/${cfg.unixSocket}
    '';
  };
}
