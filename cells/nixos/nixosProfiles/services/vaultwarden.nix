{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;

  cfg = config.services.vaultwarden.config;

  dbCfg = {
    user = config.users.users.vaultwarden.name;
    group = config.users.groups.vaultwarden.name;
    name = "vaultwarden";
  };
in {
  age.secrets.vaultwarden = {
    file = "${self}/secrets/nixos/profiles/cloud/vaultwarden.age";
    owner = dbCfg.user;
    group = dbCfg.group;
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      domain = mkDefault "https://vault.${config.networking.domain}";
      invitationsAllowed = false;
      rocketPort = 8222;
      rocketLog = "critical";
      logLevel = "warn";
      extendedLogging = true;
      signupsAllowed = false;
      showPasswordHint = false;
      websocketEnabled = true;
      websocketPort = 3012;
      websocketAddress = "localhost";
      webVaultEnabled = true;
      databaseUrl = "postgresql://%2Frun%2Fpostgresql/${dbCfg.name}";
      smtpHost = "smtp.eu.mailgun.org";
      smtpPort = 465;
      smtpSecurity = "force_tls";
      smtpFrom = mkDefault "vaultwarden@${config.networking.domain}";
    };
  };

  services.postgresql = {
    ensureDatabases = [dbCfg.name];
    ensureUsers = [
      {
        name = dbCfg.user;
        ensurePermissions = {
          "DATABASE ${dbCfg.name}" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.logrotate.settings.vaultwarden = {
    files = ["/var/log/vaultwarden/*.log"];
    # Perform logrotation as the vaultwarden user and group
    su = "${dbCfg.user} ${dbCfg.group}";
    # Rotate daily
    frequency = "daily";
  };

  services.caddy.virtualHosts.vaultwarden = {
    hostName = lib.removePrefix "https://" cfg.domain;
    extraConfig = ''
      import common
      import useCloudflare

      reverse_proxy 127.0.0.1:${toString cfg.rocketPort} {
        header_up Host {host}
        header_up X-Real-IP {remote_host}
      }

      reverse_proxy /notifications/hub 127.0.0.1:${toString cfg.websocketPort} {
        header_up Host {host}
      }

    '';
    # TODO: access admin page via tailscale
    # respond /admin* "The admin panel is disabled, please configure the 'ADMIN_TOKEN' variable to enable it"
  };
}
