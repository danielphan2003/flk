{ pkgs, config, lib, ... }:
let
  inherit (lib.our) appendString;
  inherit (lib.our.persistence) mkTmpfilesPersist;
  persistPath = config.boot.persistence.path;
in
{
  services.bitwarden_rs = {
    enable = true;
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
      enableDbWal = false;
    };
    environmentFile = "/run/secrets/bitwarden";
    backupDir = "${persistPath}/backups/vault";
  };

  systemd.services.backup-bitwarden_rs = {
    environment.DATA_FOLDER = lib.mkForce "${persistPath}/var/lib/bitwarden_rs";
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

  systemd.tmpfiles.rules = lib.mkIf config.boot.persistence.enable mkTmpfilesPersist {
    inherit persistPath;
    paths = appendString "/var/lib/bitwarden_rs/" [
      "attachments"
      "db.sqlite3"
      "icon_cache"
      "rsa_key.der"
      "rsa_key.pem"
      "rsa_key.pub.der"
    ];
  };
}