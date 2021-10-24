{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      dosfstools
      du-dust
      gnufdisk
      gptfdisk
      ncdu
      ntfs2btrfs
      ntfs3g
      parted
      ;
  };
}
