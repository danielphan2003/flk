{ pkgs, lib, config, ... }: {
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;

  hardware.pulseaudio.enable = lib.mkForce (!config.services.pipewire.enable);

  systemd.services.rtkit-daemon.serviceConfig.ExecStart = [
    "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
  ];

  services.pipewire = {
    enable = true;
    # alsa is optional
    alsa.enable = true;
    alsa.support32Bit = lib.mkDefault true;
    # needed for osu
    pulse.enable = true;

    media-session.enable = true;

    # the star of the show
    lowLatency.enable = true;

    # defaults (no need to be set unless modified)
    lowLatency = {
      quantum = 128; # usually a power of 2
      rate = 48000;
    };
  };

  # make pipewire realtime-capable
  security.rtkit.enable = true;
}
