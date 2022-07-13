{profiles, suites}: {
  suites = {
    inherit
      (suites)
      desktop
      ephemeral
      streaming
      ;
  };

  desktop.browsers = {inherit (profiles.desktop.browsers) chromium edge;};

  desktop.games = {inherit (profiles.desktop.games) minecraft;};

  desktop.window-managers = {
    inherit
      (profiles.desktop.window-managers)
      # awesome
      hyprland
      sway
      ;
  };

  programs = {
    inherit (profiles.programs)
      alacritty
      direnv
      eww
      git
      gpg
      idea
      nwg-launchers
      vscodium
      wayland
      wezterm
      winapps
      ;
  };

  programs.editors = {inherit (profiles.programs.editors) neovim;};

  services = {
    inherit
      (profiles.services)
      avizo
      gammastep
      kanshi
      mako
      waybar
      wayvnc
      ;
  };
}
