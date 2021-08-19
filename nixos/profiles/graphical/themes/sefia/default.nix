{ pkgs, lib, ... }:
let
  inherit (lib) catAttrs attrValues;

  theme = {
    gtk = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    font = {
      name = "SF Pro Display";
      size = 11;
      package = pkgs.otf-apple;
    };

    cursor = {
      name = "Bibata_Ice";
      package = pkgs.bibata-cursors;
    };

    icon = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    sddm = {
      name = "chili";
      package = pkgs.sddm-chili;
    };
  };

  inherit (theme) gtk font cursor icon sddm;

  packages = catAttrs "package" (attrValues theme);
in
{
  environment.sessionVariables = {
    GTK2_RC_FILES =
      let
        iconrc = pkgs.writeText "iconrc" ''
          gtk-icon-theme-name="${icon.name}"
          gtk-cursor-theme-name="${cursor.name}"
        '';
      in
      [
        "${iconrc}"
        "${gtk.package}/share/themes/${gtk.name}/gtk-2.0/gtkrc"
      ];
  };

  environment.systemPackages = packages ++ [
    (pkgs.buildCursorTheme cursor.name)
  ];

  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-font-name=${font.name} ${builtins.toString font.size}
      gtk-icon-theme-name=${icon.name}
      gtk-theme-name=${gtk.name}
      gtk-cursor-theme-name=${cursor.name}
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=none
    '';
    mode = "444";
  };

  services.xserver.displayManager.sddm = {
    theme = sddm.name;
    settings = {
      Theme = {
        CursorTheme = "${cursor.name}";
      };
    };
  };
}
