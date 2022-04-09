{
  self,
  config,
  lib,
  pkgs,
  suites,
  ...
}: let
  inherit (config.networking) domain;
in {
  imports = suites.pik2;

  # TODO: create new wireless network for guests
  networking.wireless.enable = false;

  services.openssh.openFirewall = true;

  networking.domain = "c-137.me";

  services.caddy.email = "acme@c-137.me";

  services.caddy.package = pkgs.caddy.override {
    plugins = [
      "github.com/caddy-dns/cloudflare"
      "github.com/danielphan2003/caddy-dynamicdns"
    ];
    vendorSha256 = "sha256-zIrOjnfvxDjJRK4JNBdGNCw8P09BmUS+1AljHJD1kVc=";
  };

  nix.maxJobs = 4;

  hardware.raspberry-pi."4" = {
    # Enable GPU acceleration
    fkms-3d.enable = true;
    audio.enable = config.services.spotifyd.enable;
  };

  hardware.bluetooth.enable = config.services.spotifyd.enable;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";
  console.keyMap = "us";

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;

    initrd.availableKernelModules = [
      "pcie_brcmstb"
      "bcm_phy_lib"
      "broadcom"
      "mdio_bcm_unimac"
      "genet"
      "bcm2835_dma"
      "i2c_bcm2835"
      "xhci_pci"
      "nvme"
      "sd_mod"
      "algif_skcipher"
      "xchacha20"
      "adiantum"
      "sha256"
      "nhpoly1305"
      "dm-crypt"
      "uas" # necessary for my UAS-enabled NVME-USB adapter
    ];

    initrd.supportedFilesystems = ["btrfs"];

    kernelModules = config.boot.initrd.availableKernelModules;

    supportedFilesystems = ["btrfs" "ntfs"];

    persistence.path = "/persist";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/persist"];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/persist" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/3044b508-d0b4-44f7-adb5-cfb10080e8df";
      randomEncryption.enable = true;
    }
  ];
}
