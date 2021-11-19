{ config, pkgs, ... }:
let
  # fqdn =
  #   let
  #     join = hostName: domain: hostName + optionalString (domain != null) ".${domain}";
  #   in join config.networking.hostName config.networking.domain;
  domain = config.networking.domain;
in
{ }
# {

# services.restic.backups.main.paths = [ "/var/lib/matrix-synapse/media" ];
# services.postgresqlBackup.databases = [ "matrix-synapse" ];

# services.postgresql.enable = true;
# services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
#   CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
#   CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
#     TEMPLATE template0
#     LC_COLLATE = "C"
#     LC_CTYPE = "C";
# '';

# services.nginx = {
#   enable = true;
#   # only recommendedProxySettings and recommendedGzipSettings are strictly required,
#   # but the rest make sense as well
#   recommendedTlsSettings = true;
#   recommendedOptimisation = true;
#   recommendedGzipSettings = true;
#   recommendedProxySettings = true;

#   virtualHosts = {
#     # This host section can be placed on a different host than the rest,
#     # i.e. to delegate from the host being accessible as ${config.networking.domain}
#     # to another host actually running the Matrix homeserver.
#     "${domain}" = {
#       locations."= /.well-known/matrix/server".extraConfig =
#         let
#           # use 443 instead of the default 8448 port to unite
#           # the client-server and server-server port for simplicity
#           server = { "m.server" = "${domain}:443"; };
#         in
#         ''
#           add_header Content-Type application/json;
#           return 200 '${builtins.toJSON server}';
#         '';
#       locations."= /.well-known/matrix/client".extraConfig =
#         let
#           client = {
#             "m.homeserver" = { "base_url" = "https://${domain}"; };
#             "m.identity_server" = { "base_url" = "https://vector.im"; };
#           };
#           # ACAO required to allow riot-web on any URL to request this json file
#         in
#         ''
#           add_header Content-Type application/json;
#           add_header Access-Control-Allow-Origin *;
#           return 200 '${builtins.toJSON client}';
#         '';

#       # forward all Matrix API calls to the synapse Matrix homeserver
#       locations."/_matrix" = {
#         proxyPass = "http://[::1]:8008"; # without a trailing /
#       };

#     };

#   };
# };
# services.matrix-synapse = {
#   enable = true;
#   server_name = domain;
#   database_type = "psycopg2";
#   database_args.password = "synapse";
#   # registration_shared_secret = "4HN2w8jVMSINK89k5qKDZgr4f8YGQ50C5EC9EOcwG4P1GzHVhIRID4DCWpdcEFZr";
#   listeners = [
#     {
#       port = 8008;
#       bind_address = "::1";
#       type = "http";
#       tls = false;
#       x_forwarded = true;
#       resources = [
#         {
#           names = [ "client" "federation" ];
#           compress = false;
#         }
#       ];
#     }
#   ];
#   extraConfig = ''
#     enable_group_creation: true
#   '';

# };
# }
