{
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.gui.platforms.xwayland];

  services.xbanish.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      feh
      maim
      rofi
      xclip
      xidlehook
      xsel
      ;
  };
}
