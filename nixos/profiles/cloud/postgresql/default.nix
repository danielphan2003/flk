{ config, lib, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
  };

  services.postgresqlBackup.enable = true;
}
