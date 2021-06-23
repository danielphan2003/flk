{ pkgs, lib, suites, config, ... }:
let ip = "192.168.1.11";
in
{
  imports = suites.themachine ++ [ ../../profiles/graphical/games ];

  networking = {
    usePredictableInterfaceNames = false;
    wireless.enable = false;
    interfaces."eth0".ipv4.addresses = [
      {
        address = ip;
        prefixLength = 16;
      }
    ];
    useDHCP = false;
    defaultGateway = "192.168.1.1";
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  security.mitigations.acceptRisk = true;

  nix.maxJobs = 4;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";

  nixpkgs.overlays =
    let
      nmap_ov = final: prev: {
        nmap = prev.nmap.overrideAttrs (_: {
          postPatch = ''
            substituteInPlace nselib/rtsp.lua \
              --replace table.unpack "\"\", --- "
          '';
        });
      };
      wine_ov = final: prev: {
        # wine-staging =
        #   (prev.wineWowPackages.staging.overrideAttrs
        #     (_:
        #       let src = final.srcs.wine-staging;
        #       in {
        #         inherit src;
        #         inherit (src) version;
        #       })
        #   ).override { };
        winetricks =
          (prev.winetricks.overrideAttrs
            (_:
              let src = final.srcs.winetricks;
              in
              {
                inherit src;
                inherit (src) version;
              })
          ).override { wine = prev.wineWowPackages.staging; };
      };
    in
    [ nmap_ov wine_ov ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    tmpOnTmpfs = true;
    kernelPackages = pkgs.linuxPackages_5_10;

    initrd.availableKernelModules = [
      "amdgpu"
      "ahci"
      "xhci_pci"
      "nvme"
      "uas"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "kvm-amd"
      "v4l2loopback"
      "snd_aloop"
    ];
    kernelModules = config.boot.initrd.availableKernelModules;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS"
    '';

    initrd.supportedFilesystems = [ "btrfs" ];
    supportedFilesystems = [ "btrfs" "ntfs" ];

    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "breeze";
      themePackages = with pkgs; [ libsForQt5.breeze-plymouth ];
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/cubum" "/mnt/danie" ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
    "/mnt/cubum" = {
      device = "/dev/disk/by-label/dandrive";
      fsType = "btrfs";
      options = [ "subvol=cubum" "compress=zstd" "nossd" ];
    };
    "/mnt/danie" = {
      device = "/dev/disk/by-label/dandrive";
      fsType = "btrfs";
      options = [ "subvol=danie" "compress=zstd" "nossd" ];
    };
  };

  swapDevices =
    [{
      device = "/dev/disk/by-partuuid/90abac81-a5e9-4506-9fe5-a2c69500efd5";
      randomEncryption.enable = true;
    }];
}
