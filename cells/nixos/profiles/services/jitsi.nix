# unmaintained
{config, ...}: {
  services.jitsi-meet = {
    enable = true;
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
