{ config, ... }:
let inherit (config.networking) domain; in
{
  services.caddy.virtualHosts."lvc-it-lib.${domain}" = {
    serverAliases = [ "loptruong-mmcl2021.${domain}" ];
    extraConfig = ''
      root * ${./src}
      file_server
    '';
  };
}
