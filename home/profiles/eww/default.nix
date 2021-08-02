{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ eww ];
  xdg.configFile."eww" = {
    source = ./config;
    recursive = true;
  };
}
