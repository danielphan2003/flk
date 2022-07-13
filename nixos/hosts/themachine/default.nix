{
  self,
  config,
  hostConfigs,
  lib,
  pkgs,
  profiles,
  suites,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (hostConfigs.hosts."${hostName}") tailscale_ip;
in {
  imports = lib.our.mkSuite {
    suites = {
      inherit
        (suites)
        ephemeral-crypt
        open-based
        modern
        personal
        play
        producer
        ;
    };

    gui.themes = {inherit (profiles.gui.themes) sefia;};

    networking.vpns = {
      inherit
        (profiles.networking.vpns)
        playit
        zerotier
        ;
    };

    programs = {
      inherit
        (profiles.programs)
        audio
        compression
        develop
        file-systems
        gnupg
        graphical
        meeting
        misc
        remote
        vpn
        yubikey
        ;
    };

    programs.chill = {
      inherit
        (profiles.programs.chill)
        reading
        watching
        weebs
        ;
    };

    security = {inherit (profiles.security) disable-mitigations;};

    services = {
      inherit
        (profiles.services)
        aria2
        # calibre-web
        
        netdata
        # peerix
        
        ;
    };

    users = {inherit (profiles.users) danie;};

    # virtualisation = {inherit (profiles.virtualisation) windows;};
  };

  networking.domain = "c-137.me";

  home-manager.users.danie.services.wayvnc.addr = tailscale_ip;

  services.fwupd.enable = true;
  services.fstrim.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";
  console.keyMap = "us";

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    tmpOnTmpfs = true;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    initrd.availableKernelModules = [
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
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

    extraModprobeConfig = ''
      options v4l2loopback devices=2 exclusive_caps=1 video_nr=10 card_label="OBS"
    '';

    initrd.supportedFilesystems = ["btrfs"];
    supportedFilesystems = ["btrfs" "ntfs"];

    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      systemd-boot.configurationLimit = 50;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      # to be overriden by profiles.gui.themes.sefia
      theme = lib.mkDefault "hexagon_dots_alt"; # or "connect";
      themePackages = lib.mkDefault [(pkgs.plymouth-themes.override {inherit (config.boot.plymouth) theme;})];
    };

    persistence.path = "/persist";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/mnt/cubum" "/mnt/danie" "/persist"];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
    "/mnt/cubum" = {
      device = "/dev/disk/by-label/dandrive";
      fsType = "btrfs";
      options = ["subvol=cubum" "compress=zstd" "nossd"];
    };
    "/mnt/danie" = {
      device = "/dev/disk/by-label/dandrive";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=danie" "compress=zstd" "nossd"];
    };
    "/persist" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
    };
  };

  fileSystems."/home".depends = ["/mnt/danie" "/mnt/cubum"];

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/90abac81-a5e9-4506-9fe5-a2c69500efd5";
      randomEncryption.enable = true;
    }
  ];
}
