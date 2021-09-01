{ config, latestModulesPath, ... }:
let inherit (config.networking) hostName; in
{
  imports = [ "${latestModulesPath}/services/web-servers/caddy/default.nix" ];
  disabledModules = [ "services/web-servers/caddy/default.nix" ];
  services.caddy = {
    enable = true;
    config = ''
      {
        ${./Caddyfile}
        import logging ${hostName}
      }
    '';
  };
}
