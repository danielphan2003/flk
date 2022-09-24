{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      czkawka
      libnotify
      pywal
      # ulauncher
      
      zathura
      ;
    inherit
      (pkgs)
      gparted
      trash-cli
      woeusb
      ;
  };
}
