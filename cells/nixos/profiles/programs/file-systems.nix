{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      dosfstools
      fd
      gnufdisk
      gptfdisk
      ncdu
      # ntfs2btrfs
      
      ntfs3g
      parted
      ;
  };
}
