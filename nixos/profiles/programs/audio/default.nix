{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      ffmpeg-full
      pamixer
      pavucontrol
      pulsemixer
      playerctl
      ;
  };
}
