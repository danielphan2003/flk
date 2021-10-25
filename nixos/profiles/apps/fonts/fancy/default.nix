{ pkgs, profiles, ... }: {
  imports = with profiles.apps.fonts; [ minimal ];

  fonts = {
    fonts = builtins.attrValues {
      inherit (pkgs)
        font-awesome
        inter
        meslo-lgs-nf
        otf-apple
        ttf-segue-ui
        twitter-color-emoji
        ;
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [ "Iosevka" "FiraCode" "Inconsolata" "MPlus" ];
      };
    };
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Font Awesome 5 Free" ];
        monospace = [ "Iosevka Nerd Font" ];
        serif = [ "New York Medium" ];
        sansSerif = [ "SF Pro Text" ];
      };
    };
  };
}