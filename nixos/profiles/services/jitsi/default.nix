{
  self,
  config,
  hostConfigs,
  lib,
  pkgs,
  ...
}: let
  inherit (hostConfigs.hosts."${config.networking.hostName}") tailnet_domain tailscale_ip tailscale_ipv6;
  cfg = config.services.jitsi-meet;
  inherit (cfg) hostName;
in {
  services.jitsi-meet = {
    enable = true;
    hostName = tailnet_domain;
    nginx.enable = false;
    caddy.enable = true;
    config = {
      default = "vi";
      preferredCodec = "vp9";
      prejoinPageEnabled = true;
      enforcePreferredCodec = true;
      desktopSharingFrameRate = {
        min = 30;
        max = 30;
      };
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  systemd.services.prosody.reloadIfChanged = config.services.prosody.enable;
}
