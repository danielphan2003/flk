{ pkgs, ... }: {
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      awestore
      lgi
      ldbus
      luarocks-nix
      luadbi-mysql
      luaposix
      rapidjson
    ];
  };
}
