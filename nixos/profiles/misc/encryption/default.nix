{
  pkgs,
  config,
  lib,
  ...
}: {
  boot.initrd.luks.devices = {
    system = {
      device = "/dev/disk/by-partlabel/cryptsystem";
      allowDiscards = true;
    };
  };

  services.btrfs.autoScrub.fileSystems = ["/" "/home" "/nix" "/var/log"];

  fileSystems = {
    "/" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };
    "/home" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };
    "/nix" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };
    "/var/log" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };
}
