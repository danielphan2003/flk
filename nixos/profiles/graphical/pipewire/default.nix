{ pkgs, lib, ... }: {
  sound.enable = true;

  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;

  systemd.services.rtkit-daemon.serviceConfig.ExecStart = [
    "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    media-session.enable = true;
  };
}
