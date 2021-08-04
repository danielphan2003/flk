{ pkgs, ... }: {
  xdg.configFile = {
    "awesome" = {
      source = ./src;
      recursive = true;
    };
    "awesome/bling".source = pkgs.luaPackages.bling;
    "awesome/layout-machi".source = pkgs.luaPackages.layout-machi;
  };

  xsession = {
    windowManager.awesome.enable = true;
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Ice";
    };
  };
}
