let
  inherit (inputs.cells) home;
  inherit (home) homeProfiles;
in {
  danie = {
    imports =
      [
        # homeProfiles.desktop.games.minecraft
        # homeProfiles.desktop.window-managers.awesome
        homeProfiles.desktop.window-managers.hyprland
        # homeProfiles.desktop.window-managers.sway
        homeProfiles.gui.platforms.wayland
      ]
      ++ cell.homeSuites.compounds
      ++ cell.homeSuites.consumables
      ++ home.homeSuites.desktop
      ++ home.homeSuites.ephemeral
      ++ home.homeSuites.streaming;

    home.sessionVariables.BROWSER = "chromium-browser";

    programs.git = {
      userEmail = "danielphan.2003@c-137.me";

      userName = "Daniel Phan";

      signing.signByDefault = true;

      signing.key = "/home/danie/.ssh/id_nistp256_sk_rk_github.pub";

      extraConfig = {
        github.user = "danielphan2003";
        gpg.format = "ssh";
      };
    };

    programs.gpg.settings.default-key = "FA6FA2660BEC2464";
  };

  compounds = with homeProfiles.programs; [
    alacritty
    chromium
    direnv
    edge
    editors.neovim
    eww
    firefox.base
    firefox.settings
    firefox.arkenfox
    firefox.disable-rfp
    firefox.fx_cast
    firefox.pywalfox
    firefox.sidebar
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
  ];

  consumables = with homeProfiles.services; [
    avizo
    gammastep
    kanshi
    mako
    swayidle
    # swhkd

    # swhks

    # wayvnc
  ];
}
