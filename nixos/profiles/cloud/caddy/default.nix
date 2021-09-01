{ lib, config, latestModulesPath, ... }:
let
  inherit (config.networking) hostName;
  inherit (config.boot.persistence) path;
in
{
  disabledModules = [ "services/web-servers/caddy/default.nix" ];
  services.caddy = {
    enable = true;
    config = ''
      {
        ${builtins.readFile ./Caddyfile}
        import logging ${hostName}
      }
    '';
  };
}
