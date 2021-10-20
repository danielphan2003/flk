{ pkgs, ... }:
let inherit (builtins) attrValues; in
{
  xdg.configFile = {
    "awesome" = {
      source = ./src;
      recursive = true;
    };
    "awesome/bling".source = pkgs.luaPackages.bling;
    "awesome/layout-machi".source = pkgs.luaPackages.layout-machi;
  };

  home.packages = attrValues {
    inherit (pkgs) rofi;
  };

  xsession = {
    windowManager.awesome.enable = true;
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Ice";
    };
  };
}