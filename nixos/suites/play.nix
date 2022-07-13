{profiles}: {
  desktop = {
    inherit (profiles.desktop) gaming;
  };

  networking.discovery = {
    inherit (profiles.networking.discovery) chromecast;
  };

  programs = {
    inherit (profiles.programs) wine;
  };
}
