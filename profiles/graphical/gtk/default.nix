{ pkgs, ... }:
let
  theme = "Materia-dark";
  themePkgs = pkgs.materia-theme;
  font = "SF Pro Display 11";
  cursor = "Bibata_Ice";
  cursorPkgs = pkgs.bibata-cursors;
  icon = "Papirus";
  iconPkgs = pkgs.papirus-icon-theme;
in
{
  environment = {
    systemPackages = [
      pkgs.cursor
      cursorPkgs
      iconPkgs
      themePkgs
    ];

    etc."xdg/gtk-3.0/settings.ini" = {
      text = ''
        [Settings]
        gtk-font-name=${font}
        gtk-icon-theme-name=${icon}
        gtk-theme-name=${theme}
        gtk-cursor-theme-name=${cursor}
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintfull
        gtk-xft-rgba=none
      '';
      mode = "444";
    };

    sessionVariables = {
      # Theme settings
      QT_QPA_PLATFORMTHEME = "gtk3";

      GTK2_RC_FILES =
        let
          gtk = ''
            gtk-icon-theme-name="${icon}"
            gtk-cursor-theme-name="${cursor}"
          '';
        in
        [
          ("${pkgs.writeText "iconrc" "${gtk}"}")
          "${themePkgs}/share/themes/${theme}/gtk-2.0/gtkrc"
        ];

      BROWSER = "chromium-browser";
    };
  };
}
