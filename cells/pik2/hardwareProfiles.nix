let
  inherit (inputs.cells) nixos;
in {
  pik2 = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      nixos.nixosProfiles.file-systems.btrfs
      nixos.nixosProfiles.hardware.argonone
      nixos.nixosProfiles.hardware.firmware
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];

    boot.initrd.availableKernelModules = [
      # crypto related
      "adiantum"
      "xchacha20"
      "nhpoly1305"

      # external nvme usb closures
      "nvme"
      "uas"
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

    boot.loader.systemd-boot.enable = false;

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/3044b508-d0b4-44f7-adb5-cfb10080e8df";
        randomEncryption.enable = true;
      }
    ];

    hardware.bluetooth.enable = config.services.spotifyd.enable;

    hardware.raspberry-pi."4" = {
      # Enable GPU acceleration
      fkms-3d.enable = true;
      audio.enable = config.services.spotifyd.enable;
    };

    # TODO: create new wireless network for guests
    networking.wireless.enable = false;

    nix.settings.max-jobs = 4;

    services.caddy.package = pkgs.caddy.override {
      plugins = [
        "github.com/jyooru/caddy-dns-cloudflare"
        "github.com/mholt/caddy-dynamicdns"
      ];
    };

    services.dnscrypt-proxy2.settings = {
      tls_cipher_suite = [52392 49199];
      max_clients = 10000;
    };
  };
}
