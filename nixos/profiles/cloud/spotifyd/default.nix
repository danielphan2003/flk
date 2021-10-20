{ config, self, ... }: {
  age.secrets.spotify.file = "${self}/nixos/profiles/cloud/spotify.age";

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username_cmd = "source ${config.age.secrets.spotify.path} && echo $SPOTIFY_USER";
        password_cmd = "source ${config.age.secrets.spotify.path} && echo $SPOTIFY_PASSWD";
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
