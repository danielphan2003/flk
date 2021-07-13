{ config, lib, ... }:
let inherit (config.boot.persistence) enable path; in
{
  services.postgresql.enable = true;

  services.postgresqlBackup.enable = true;

  environment.persistence."${path}" = lib.mkIf enable {
    directories = [
      "/var/backup/postgresql"
      "/var/lib/postgresql"
    ];
  };
}