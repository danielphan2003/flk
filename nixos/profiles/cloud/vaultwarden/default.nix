{ pkgs, config, lib, self, ... }:
let
  inherit (lib) concatStringsSep mkAfter;
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) tailnet_alias;
  inherit (config.services.vaultwarden.config) rocketPort websocketPort;

  tailnet-domain = "${hostName}.${tailnet_alias}";

  vaultwarden-age-key = "${self}/secrets/nixos/profiles/cloud/vaultwarden.age";
in
{
  age.secrets.vaultwarden = {
    file = vaultwarden-age-key;
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      domain = "https://${tailnet-domain}/vault";
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
      databaseUrl = "postgresql://%2Frun%2Fpostgresql/vaultwarden";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [{
      name = "vaultwarden";
      ensurePermissions = {
        "DATABASE vaultwarden" = "ALL PRIVILEGES";
      };
    }];
  };

  services.logrotate.paths.vaultwarden = {
    path = "/var/log/vaultwarden/*.log";
    # Perform logrotation as the vaultwarden user and group
    user = "vaultwarden";
    group = "vaultwarden";
    # Rotate daily
    frequency = "daily";
    # Keep 4 rotations of log files before removing or mailing to the address specified in a mail directive
    extraConfig = ''
      # Rotate when the size is bigger than 5MB
      rotate 4
      size 5Ms
      # Compress old log files
      compress
      # Truncate the original log file in place after creating a copy
      copytruncate
      # Don't panic if not found
      missingok
      # Don't rotate log if file is empty
      notifempty
      # Add date instaed of number to rotated log file
      dateext
      # Date format of dateext
      dateformat "-%Y-%m-%d-%s"
    '';
  };

  services.caddy.virtualHosts =
    let
      handleWWW = ''
        reverse_proxy 127.0.0.1:${toString rocketPort} {
          header_up Host {host}
          header_up X-Real-IP {remote_host}
        }
      '';
      handleNotify = ''
        reverse_proxy /notifications/hub 127.0.0.1:${toString websocketPort} {
          header_up Host {host}
        }
      '';
    in
    {
      "vault.${domain}" = {
        serverAliases = [ "bw.${domain}" ];
        extraConfig = ''
          rewrite * /vault{uri}
          ${handleWWW}
          ${handleNotify}
          respond /vault/admin* "The admin panel is disabled, please configure the 'ADMIN_TOKEN' variable to enable it"
        '';
      };
      "${tailnet-domain}".extraConfig = mkAfter ''
        handle /vault* {
          ${handleWWW}
        }
        handle /vault/notifications/hub {
          ${handleNotify}
        }
      '';
    };
}
