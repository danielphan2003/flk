{ self, config, hostConfigs, lib, pkgs, ... }:
let
  inherit (hostConfigs.hosts."${config.networking.hostName}") tailnet_domain;
in
{
  services.jitsi-meet = {
    enable = true;
    hostName = tailnet_domain;
    nginx.enable = false;
    caddy.enable = true;
    config = {
      preferredCodec = "vp9";
      enforcePreferredCodec = true;
      desktopSharingFrameRate = {
        min = 30;
        max = 30;
      };
    };
  };
}
