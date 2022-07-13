{ lib, ... }: {
  fonts.enableDefaultFonts = lib.mkDefault true;

  fonts.fontconfig.enable = lib.mkDefault false;
}
