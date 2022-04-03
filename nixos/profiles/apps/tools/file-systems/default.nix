{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      dosfstools
      gnufdisk
      gptfdisk
      ncdu
      nix-du
      nix-tree
      ntfs2btrfs
      ntfs3g
      parted
      ;
  };
}
