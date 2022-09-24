{
  inputs,
  cell,
}: let
  homeProfiles = inputs.Cells.home.profiles;
in {
  # desktop.games = {inherit (homeProfiles.desktop.games) minecraft;};

  desktop.window-managers = {
    inherit
      (homeProfiles.desktop.window-managers)
      # awesome
      
      hyprland
      # sway
      
      ;
  };

  gui.platforms = {inherit (homeProfiles.gui.platforms) wayland;};

  programs = {
    inherit
      (homeProfiles.programs)
      alacritty
      chromium
      direnv
      edge
      eww
      git
      gpg
      hyprpaper
      jetbrains-idea
      nwg-launchers
      swaylock
      vscodium
      waybar
      wayland
      wezterm
      ;

    inherit
      (homeProfiles.programs.firefox)
      base
      settings
      arkenfox
      disable-rfp
      fx_cast
      pywalfox
      sidebar
      ;
  };

  programs.editors = {inherit (homeProfiles.programs.editors) neovim;};

  services = {
    inherit
      (homeProfiles.services)
      avizo
      gammastep
      kanshi
      mako
      swayidle
      # swhkd
      
      # swhks
      
      wayvnc
      ;
  };
}
