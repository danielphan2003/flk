{
  profiles,
  suites,
}: {
  imports = [suites.graphics];

  desktop = {inherit (profiles.desktop) pipewire;};

  desktop.login-managers = {inherit (profiles.desktop.login-managers) greetd;};

  gui = {inherit (profiles.gui) gtk misc;};

  gui.platforms = {inherit (profiles.gui.platforms) wayland;};
}
