{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      pamixer
      pavucontrol
      pulsemixer
      playerctl
      ;
  };
}
