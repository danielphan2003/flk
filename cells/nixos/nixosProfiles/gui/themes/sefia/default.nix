{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix.image = ./wallpaper.jpg;

  stylix.fonts = {
    serif = {
      package = pkgs.otf-apple;
      name = "New York Medium";
    };
    sansSerif = {
      package = pkgs.otf-apple;
      name = "SF Pro Text";
    };
    monospace = {
      package = pkgs.nerdfonts.override {
        fonts = ["Iosevka" "FiraCode" "Inconsolata" "MPlus"];
      };
      name = "Iosevka Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  home-manager.sharedModules = [
    {
      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Ice";
        gtk.enable = true;
        x11.enable = true;
      };

      gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
    }
  ];

  services.xserver.displayManager.sddm.settings = {
    Theme.CursorTheme = "Bibata-Ice";
  };
}
