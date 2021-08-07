{ pkgs, lib, ... }:
let
  theme = "Materia-dark";
  themePkgs = pkgs.materia-theme;
  font = "SF Pro Display 11";
  cursor = "Bibata_Ice";
  cursorPkgs = pkgs.bibata-cursors;
  icon = "Papirus";
  iconPkgs = pkgs.papirus-icon-theme;

  linuxSpecific =
    if lib.hasInfix "linux" pkgs.system
    then
      {
        home.persistence."/mnt/danie" = {
          directories = [
            ".gnupg"
            ".ssh"
            ".nixops"
            ".local/share/keyrings"
            ".local/share/direnv"
            "av"
            "docs"
            "dl"
            "mus"
            "games"
            "pics"
          ];
          allowOther = true;
        };

        xdg.userDirs = {
          enable = true;
          desktop = "$HOME/desk";
          documents = "$HOME/docs";
          download = "$HOME/dl";
          music = "$HOME/mus";
          pictures = "$HOME/pics";
          publicShare = "$HOME/pub";
          templates = "$HOME/docs/templates";
          videos = "$HOME/av";
        };
      }
    else { };
in
# linuxSpecific
# //
# lib.recursiveUpdate linuxSpecific
{
  home.packages = with pkgs; [ xdg_utils ];
  home.sessionVariables = {
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    ASPELL_CONF = ''
      per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
      personal $XDG_CONFIG_HOME/aspell/en_US.pws;
      repl $XDG_CONFIG_HOME/aspell/en.prepl;
    '';
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    HISTFILE = "$XDG_DATA_HOME/bash/history";
    INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };

  xdg.configFile."gtk-3.0/settings.ini".text = ''
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
}
