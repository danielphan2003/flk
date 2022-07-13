{
  profiles,
  suites,
}: {
  imports = [suites.networking];

  virtualisation = {inherit (profiles.virtualisation) headless minimal;};
}
