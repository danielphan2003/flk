{ lib, config, ... }:
let inherit (config.networking) hostName; in
{
  services.caddy = {
    enable = true;
    config = ''
      ${builtins.readFile ./Caddyfile}
    '';
  };
}
