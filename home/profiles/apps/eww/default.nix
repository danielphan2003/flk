{ pkgs, lib, ... }: {
  services.eww-mpris = {
    enable = true;
    template = {
      box = ./config/templates/mpris/box.yuck;
      button = ./config/templates/mpris/button.yuck;
    };
  };

  services.eww.enable = true;

  xdg.configFile."eww".source = ./config;
}
