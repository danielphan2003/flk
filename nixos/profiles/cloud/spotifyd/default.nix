{ config, self, ... }:
let inherit (config.age.secrets.spotify) path; in
{
  age.secrets.spotify.file = "${self}/secrets/nixos/profiles/cloud/spotify.age";

  systemd.services.spotifyd = {
    serviceConfig.EnvironmentFile = path;
  };

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username_cmd = "echo $SPOTIFY_USER";
        password_cmd = "echo $SPOTIFY_PASSWD";
        device_name = config.networking.hostName;
        cache_path = "/var/cache/spotify";
        initial_volume = "100";
        backend = "alsa";
        # device = alsa_audio_device; # Given by `aplay -L`
        mixer = "PCM";
        volume-controller = "alsa"; # or alsa_linear, or softvol
        bitrate = 320;
        volume-normalisation = true;
        normalisation-pregain = -10;
      };
    };
  };
}
