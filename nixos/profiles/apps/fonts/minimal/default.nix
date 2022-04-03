{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  fonts = {
    enableDefaultFonts = mkDefault true;
    fontconfig.enable = mkDefault false;
  };
}
