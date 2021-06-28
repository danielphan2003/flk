{ config, lib, ... }:
let
  inherit (lib.our) appendString;
  inherit (lib.our.persistence) mkTmpfilesPersist;
  persistPath = config.boot.persistence.path;
in
{
  services.postgresql = {
    enable = true;
    dataDir = lib.mkIf config.boot.persistence.enable "${persistPath}/var/lib/postgresql";
  };

  services.postgresqlBackup = {
    enable = true;
    location = "${persistPath}/backups/db";
  };
}