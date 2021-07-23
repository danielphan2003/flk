{ pkgs, config, lib, self, ... }: {
  age.secrets.bitwarden.file = "${self}/secrets/bitwarden.age";

  services.bitwarden_rs = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = "/run/secrets/bitwarden";
    config = {
      domain = "https://bw.${config.networking.domain}";
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
      webVaultFolder = "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
      webVaultEnabled = true;
      databaseUrl = "postgresql://%2Frun%2Fpostgresql/vaultwarden";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [{
      name = "bitwarden_rs";
      ensurePermissions = {
        "DATABASE vaultwarden" = "ALL PRIVILEGES";
      };
    }];
  };

  services.logrotate.paths.bitwarden_rs = {
    path = "/var/log/bitwarden/*.log";
    # Perform logrotation as the bitwarden user and group
    user = "bitwarden_rs";
    group = "bitwarden_rs";
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
}
