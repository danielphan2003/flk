{...}: {
  # https://github.com/NixOS/nixpkgs/pull/179823
  # environment.etc.crypttab = {
  #   enable = true;
  #   text = ''
  #     cryptroot "${config.boot.initrd.luks.devices.system.device}" - fido2-device=auto
  #   '';
  # };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/90abac81-a5e9-4506-9fe5-a2c69500efd5";
      randomEncryption.enable = true;
    }
  ];

  # out of commission
  # services.btrfs.autoScrub.fileSystems = ["/mnt/cubum" "/mnt/danie"];
  # fileSystems = {
  #   "/mnt/cubum" = {
  #     device = "/dev/disk/by-label/dandrive";
  #     fsType = "btrfs";
  #     options = ["subvol=cubum" "compress=zstd" "nossd"];
  #   };
  #   "/mnt/danie" = {
  #     device = "/dev/disk/by-label/dandrive";
  #     fsType = "btrfs";
  #     neededForBoot = true;
  #     options = ["subvol=danie" "compress=zstd" "nossd"];
  #   };
  #   "/home".depends = ["/mnt/danie" "/mnt/cubum"];
  # };
}
