{
  profiles,
  suites,
}: {
  imports = [suites.networking];

  documentation = {inherit (profiles.documentation) disabled;};

  virtualisation = {inherit (profiles.virtualisation) headless;};
}
