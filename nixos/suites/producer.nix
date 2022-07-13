{profiles}: {
  programs = {
    inherit (profiles.programs) im;
  };

  programs.chill = {
    inherit (profiles.programs.chill) spotify;
  };
}
