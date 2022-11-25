let
  inherit (inputs) cells;
in {
  themachine = {pkgs, ...}: {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      cells.nixos.nixosProfiles.file-systems.btrfs
      cells.nixos.nixosProfiles.system.encryption.tpm
    ];

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelModules = [
      # external usb closures
      "uas"
      "usb_storage"

      # AMD hardware virtualisation
      "kvm-amd"
    ];

    programs.gamemode.enable = false;

    services.dnscrypt-proxy2.settings = {
      max_clients = 10000;
    };

    boot.loader.systemd-boot.configurationLimit = 15;

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
  };
}
