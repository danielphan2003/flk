{
  profiles,
  suites,
}: {
  imports = [suites.graphics];

  desktop.window-managers = {inherit (profiles.desktop.window-managers) awesome;};

  gui.platforms = {inherit (profiles.gui.platforms) x11;};
}
