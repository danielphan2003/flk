{
  config,
  lib,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  services.postgresqlBackup = {
    enable = true;
    compression = "zstd";
  };

  environment.systemPackages = let
    newPostgresql = pkgs.postgresql_14;
    nixosPsqlSchema = let
      inherit (config.services.postgresql.package) psqlSchema;
    in
      if psqlSchema == "10.0"
      then "10"
      else if psqlSchema == "11.1"
      then "11"
      else psqlSchema;
  in [
    (pkgs.writeScriptBin "upgrade-pg-cluster" ''
      set -eux

      if [ "${nixosPsqlSchema}" -ge "${newPostgresql.psqlSchema}" ]; then
        echo "The specified psqlSchema in NixOS config is the same as or newer than the 'new' one"
        exit 1
      fi

      # XXX it's perhaps advisable to stop all services that depend on postgresql
      systemctl stop postgresql

      # XXX replace `<new version>` with the psqlSchema here
      export NEWDATA="/var/lib/postgresql/${toString newPostgresql.psqlSchema}"

      # XXX specify the postgresql package you'd like to upgrade to
      export NEWBIN="${newPostgresql}/bin"

      export OLDDATA="${config.services.postgresql.dataDir}"
      export OLDBIN="${config.services.postgresql.package}/bin"

      install -d -m 0700 -o postgres -g postgres "$NEWDATA"
      cd "$NEWDATA"
      doas -u postgres $NEWBIN/initdb -D "$NEWDATA"

      doas -u postgres $NEWBIN/pg_upgrade \
        --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
        --old-bindir $OLDBIN --new-bindir $NEWBIN \
        "$@"
    '')
  ];
}
