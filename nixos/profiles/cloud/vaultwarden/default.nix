{ pkgs, config, lib, self, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) nameserver;
  inherit (config.services.vaultwarden.config) rocketPort websocketPort;
in
{
  age.secrets.vaultwarden.file = "${self}/secrets/nixos/profiles/cloud/vaultwarden.age";

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = "/run/secrets/vaultwarden";
    config = {
      domain = "https://vault.${domain}";
      invitationsAllowed = false;
      rocketPort = 8222;
      rocketLog = "critical";
      logLevel = "warn";
      extendedLogging = true;
      signupsAllowed = false;
      showPasswordHint = false;
      websocketEnabled = true;
      websocketPort = 3012;
      websocketAddress = "127.0.0.1";
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

  services.caddy.virtualHosts."vault.${domain}" = {
    serverAliases = [ "bw.${domain}" ];
    extraConfig = ''
      reverse_proxy localhost:${toString rocketPort} {
        header_up Host bw.${domain}
        header_up X-Real-IP {remote_host}
      }
      reverse_proxy /notifications/hub localhost:${toString websocketPort}" {
        header_up Host bw.${domain}
      }
      # respond /admin* "The admin panel is disabled, please configure the 'ADMIN_TOKEN' variable to enable it"
    '';
  };

  # services.caddy.virtualHosts."bw.${hostName}" = {
  #   serverAliases = [ "bw.${nameserver}" ];
  #   extraConfig = ''
  #     reverse_proxy localhost:${toString rocketPort} {
  #       header_up Host bw.${domain}
  #       header_up X-Real-IP {remote_host}
  #     }
  #     reverse_proxy /notifications/hub localhost:${toString websocketPort}" {
  #       header_up Host bw.${domain}
  #     }
  #   '';
  # };
}
