{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      gnufdisk
      gparted
      parted
      trash-cli
      woeusb
      ;
  };
}
