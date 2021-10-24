{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      dosfstools
      gnufdisk
      gptfdisk
      ncdu
      ntfs2btrfs
      ntfs3g
      parted
      ;
  };
}
