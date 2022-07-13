{
  profiles,
  suites,
}: {
  imports = [suites.work];

  desktop = {inherit (profiles.desktop) drivers;};

  programs = {inherit (profiles.programs) gnome qt qutebrowser;};
}
