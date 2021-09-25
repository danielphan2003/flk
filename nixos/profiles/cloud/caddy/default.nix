{ lib, config, ... }:
let inherit (config.networking) hostName; in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    config = lib.mkBefore ''
      ${builtins.readFile ./Caddyfile}
    '';
  };
}
