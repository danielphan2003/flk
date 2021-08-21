{ pkgs, lib, ... }: {
  services.eww-mpris.enable = builtins.elem pkgs.system pkgs.eww-mpris.platforms;
  services.eww.enable = true;
  # xdg.configFile."eww" = {
  #   source = ./config;
  #   # recursive = true;
  # };
}
