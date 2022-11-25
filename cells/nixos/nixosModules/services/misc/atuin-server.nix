{
  config,
  pkgs,
  lib,
  ...
}: {
  # with lib;

  # let
  #   cfg = config.services.atuin-server;

  #   tomlFmt = pkgs.formats.toml {};

  #   configToml = tomlFmt.generate "atuin-server.toml" cfg.settings;

  #   defaultUser = "atuin-server";
  # in
  # {
  #   options = {
  #     services.atuin-server = {
  #       enable = mkOption {
  #         type = types.bool;
  #         default = false;
  #         example = true;
  #         description = ''
  #           Whether to enable the atuin server.

  #           Once enabled you need to create an admin user by invoking the
  #           shell command <literal>atuin-server createsuperuser</literal> with
  #           the user specified by the <literal>user</literal> option or a superuser.
  #           Then you can login and create accounts on your-atuin-server.com/admin
  #         '';
  #       };

  #       dataDir = mkOption {
  #         type = types.str;
  #         default = "/var/lib/atuin-server";
  #         description = "Directory to store the atuin server data.";
  #       };

  #       port = mkOption {
  #         type = with types; nullOr port;
  #         default = 8001;
  #         description = "Port to listen on.";
  #       };

  #       openFirewall = mkOption {
  #         type = types.bool;
  #         default = false;
  #         description = ''
  #           Whether to open ports in the firewall for the server.
  #         '';
  #       };

  #       unixSocket = mkOption {
  #         type = with types; nullOr str;
  #         default = null;
  #         description = "The path to the socket to bind to.";
  #         example = "/run/atuin-server/atuin-server.sock";
  #       };

  #       settings = mkOption {
  #         type = lib.types.submodule {
  #           freeformType = tomlFmt.type;

  #           options = {
  #             global = {
  #               debug = mkOption {
  #                 type = types.bool;
  #                 default = false;
  #                 description = ''
  #                   Whether to set django's DEBUG flag.
  #                 '';
  #               };
  #               secret_file = mkOption {
  #                 type = with types; nullOr str;
  #                 default = null;
  #                 description = ''
  #                   The path to a file containing the secret
  #                   used as django's SECRET_KEY.
  #                 '';
  #               };
  #               static_root = mkOption {
  #                 type = types.str;
  #                 default = "${cfg.dataDir}/static";
  #                 defaultText = literalExpression ''"''${config.services.atuin-server.dataDir}/static"'';
  #                 description = "The directory for static files.";
  #               };
  #               media_root = mkOption {
  #                 type = types.str;
  #                 default = "${cfg.dataDir}/media";
  #                 defaultText = literalExpression ''"''${config.services.atuin-server.dataDir}/media"'';
  #                 description = "The media directory.";
  #               };
  #             };
  #             allowed_hosts = {
  #               allowed_host1 = mkOption {
  #                 type = types.str;
  #                 default = "0.0.0.0";
  #                 example = "localhost";
  #                 description = ''
  #                   The main host that is allowed access.
  #                 '';
  #               };
  #             };
  #             database = {
  #               engine = mkOption {
  #                 type = types.enum [ "django.db.backends.sqlite3" "django.db.backends.postgresql" ];
  #                 default = "django.db.backends.sqlite3";
  #                 description = "The database engine to use.";
  #               };
  #               name = mkOption {
  #                 type = types.str;
  #                 default = "${cfg.dataDir}/db.sqlite3";
  #                 defaultText = literalExpression ''"''${config.services.atuin-server.dataDir}/db.sqlite3"'';
  #                 description = "The database name.";
  #               };
  #             };
  #           };
  #         };
  #         default = {};
  #         description = ''
  #           Configuration for <package>atuin-server</package>. Refer to
  #           <link xlink:href="https://github.com/etesync/server/blob/master/atuin-server.toml.example" />
  #           and <link xlink:href="https://github.com/etesync/server/wiki" />
  #           for details on supported values.
  #         '';
  #         example = {
  #           global = {
  #             debug = true;
  #             media_root = "/path/to/media";
  #           };
  #           allowed_hosts = {
  #             allowed_host2 = "localhost";
  #           };
  #         };
  #       };

  #       user = mkOption {
  #         type = types.str;
  #         default = defaultUser;
  #         description = "User under which atuin server runs.";
  #       };
  #     };
  #   };

  #   config = mkIf cfg.enable {

  #     environment.systemPackages = with pkgs; [
  #       (runCommand "atuin-server" {
  #         buildInputs = [ makeWrapper ];
  #       } ''
  #         makeWrapper ${pythonEnv}/bin/atuin-server \
  #           $out/bin/atuin-server \
  #           --chdir ${escapeShellArg cfg.dataDir} \
  #           --prefix atuin_EASY_CONFIG_PATH : "${configToml}"
  #       '')
  #     ];

  #     systemd.tmpfiles.rules = [
  #       "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
  #     ];

  #     systemd.services.atuin-server = {
  #       description = "An atuin (EteSync 2.0) server";
  #       after = [ "network.target" "systemd-tmpfiles-setup.service" ];
  #       wantedBy = [ "multi-user.target" ];
  #       serviceConfig = {
  #         User = cfg.user;
  #         Restart = "always";
  #         WorkingDirectory = cfg.dataDir;
  #       };
  #       environment = {
  #         PYTHONPATH = "${pythonEnv}/${pkgs.python3.sitePackages}";
  #         atuin_EASY_CONFIG_PATH = configToml;
  #       };
  #       preStart = ''
  #         # Auto-migrate on first run or if the package has changed
  #         versionFile="${cfg.dataDir}/src-version"
  #         if [[ $(cat "$versionFile" 2>/dev/null) != ${pkgs.atuin-server} ]]; then
  #           ${pythonEnv}/bin/atuin-server migrate --no-input
  #           ${pythonEnv}/bin/atuin-server collectstatic --no-input --clear
  #           echo ${pkgs.atuin-server} > "$versionFile"
  #         fi
  #       '';
  #       script =
  #         let
  #           networking = if cfg.unixSocket != null
  #           then "-u ${cfg.unixSocket}"
  #           else "-b 0.0.0.0 -p ${toString cfg.port}";
  #         in ''
  #           cd "${pythonEnv}/lib/atuin-server";
  #           ${pythonEnv}/bin/daphne ${networking} \
  #             atuin_server.asgi:application
  #         '';
  #     };

  #     users = optionalAttrs (cfg.user == defaultUser) {
  #       users.${defaultUser} = {
  #         isSystemUser = true;
  #         group = defaultUser;
  #         home = cfg.dataDir;
  #       };

  #       groups.${defaultUser} = {};
  #     };

  #     networking.firewall = mkIf cfg.openFirewall {
  #       allowedTCPPorts = [ cfg.port ];
  #     };
  #   };
}
