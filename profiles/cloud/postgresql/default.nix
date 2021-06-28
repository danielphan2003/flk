{ config, lib, ... }:
let
  inherit (lib.our) appendString;
  inherit (lib.our.persistence) mkTmpfilesPersist;
  persistDir = config.boot.persistence.path;
in
{
  services.postgresql.enable = true;

  services.postgresqlBackup = {
    enable = true;
    location = "${persistPath}/backups/db";
  };

  systemd.tmpfiles.rules = lib.mkIf config.boot.persistence.enable [
    "L /var/lib/postgresql - - - - ${persistPath}/var/lib/postgresql"
  ];
}