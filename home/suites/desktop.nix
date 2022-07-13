{profiles}: {
  desktop = {inherit (profiles.desktop) xdg;};

  desktop.browsers = {inherit (profiles.desktop.browsers) firefox;};

  services = {inherit (profiles.services) swhkd udiskie uget;};
}
