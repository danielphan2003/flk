{config, pkgs, profiles, ...}: {
  imports = [profiles.services.sxhkd];

  xdg.configFile."swhkd/swhkdrc".source = config.xdg.configFile."sxhkd/sxhkdrc".source;

  services.sxhkd.package = pkgs.swhkd;
}
