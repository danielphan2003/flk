{
  config,
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.fonts.minimal];

  home-manager.sharedModules = [{fonts.fontconfig.enable = config.fonts.fontconfig.enable;}];

  fonts.fonts = builtins.attrValues {
    inherit
      (pkgs)
      font-awesome
      inter
      meslo-lgs-nf
      ttf-segue-ui
      twitter-color-emoji
      ;
  };

  fonts.fontconfig.enable = true;
}
