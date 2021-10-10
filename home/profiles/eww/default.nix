{ pkgs, lib, ... }: {
  services.eww-mpris.enable = true;
  services.eww.enable = true;
  xdg.configFile."eww" = {
    source = ./config;
    # recursive = true;
  };
}
