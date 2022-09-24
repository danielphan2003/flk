{
  pkgs,
  lib,
  ...
}: {
  services.eww-mpris = {
    enable = true;
    template = {
      box = ./templates/mpris/box.yuck;
      button = ./templates/mpris/button.yuck;
    };
  };

  services.eww.enable = true;

  xdg.configFile."eww".source = ./.;
}
