{profiles, ...}: {
  imports = [profiles.fonts.minimal];

  fonts.fontconfig.enable = true;

  fonts.fontDir.enable = true;

  programs.xwayland.enable = true;
}
