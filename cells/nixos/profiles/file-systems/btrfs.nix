{
  config,
  lib,
  ...
}: {
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems =
      [
        "/"
        "/home"
        "/nix"
        "/var/log"
      ]
      ++ lib.optionals config.boot.persistence.enable [config.boot.persistence.path];
  };

  boot.initrd.supportedFilesystems = ["btrfs"];

  fileSystems =
    {
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
    }
    // (lib.optionalAttrs config.boot.persistence.enable {
      "${config.boot.persistence.path}" = {
        device = "/dev/mapper/system";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd" "noatime"];
      };
    });
}
