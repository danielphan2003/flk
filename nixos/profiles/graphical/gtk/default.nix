{ pkgs, ... }:
let
  theme = "Materia-dark";
  themePkg = pkgs.materia-theme;
  font = "SF Pro Display 11";
  cursor = "Bibata_Ice";
  cursorPkg = pkgs.bibata-cursors;
  icon = "Papirus";
  iconPkg = pkgs.papirus-icon-theme;
in
{
  environment.systemPackages = [ pkgs.cursor cursorPkg iconPkg themePkg ];

  environment.etc."xdg/gtk-3.0/settings.ini" = {
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

  environment.sessionVariables = {
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
        "${themePkg}/share/themes/${theme}/gtk-2.0/gtkrc"
      ];

    # Use librsvg's gdk-pixbuf loader cache file as it enables gdk-pixbuf to load
    # SVG files (important for icons)
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg}/lib/gdk-pixbuf-2.0/*/loaders.cache)";

    BROWSER = "chromium-browser";
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
