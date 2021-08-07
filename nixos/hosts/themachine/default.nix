{ pkgs, lib, suites, config, self, ... }:
let ip = "192.168.1.11";
in
{
  imports = suites.themachine ++ [ ../../profiles/graphical/games ];

  age.secrets.duckdns.file = "${self}/secrets/nixos/profiles/cloud/duckdns.age";

  networking = {
    domain = "themachinix.duckdns.org";
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
    firewall.allowedTCPPorts = [ 5901 ];
    firewall.allowedUDPPorts = [ 5901 ];
  };

  services.duckdns = {
    enable = true;
    domain = "themachinix";
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

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
    in
    [ nmap_ov ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    tmpOnTmpfs = true;
    kernelPackages = pkgs.linuxPackages_5_12;

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
      # theme = "hexagon_dots_alt"; # "connect";
      # themePackages = [ (pkgs.plymouth-themes.override { inherit (config.boot.plymouth) theme; }) ];
    };

    persistence.path = "/persist";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/mnt/cubum" "/mnt/danie" "/persist" ];
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
      neededForBoot = true;
      options = [ "subvol=danie" "compress=zstd" "nossd" ];
    };
    "/persist" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };
  };

  swapDevices =
    [{
      device = "/dev/disk/by-partuuid/90abac81-a5e9-4506-9fe5-a2c69500efd5";
      randomEncryption.enable = true;
    }];
}
