{ pkgs, lib, suites, config, self, ... }:
let
  inherit (builtins) removeAttrs;
  inherit (config.networking) domain hostName;
in
{
  imports = suites.pik2;

  age.secrets.duckdns.file = "${self}/secrets/nixos/profiles/cloud/duckdns.age";

  networking = {
    domain = "${hostName}.duckdns.org";
    wireless.enable = false;
  };

  services.openssh.openFirewall = true;

  services.duckdns = {
    enable = true;
    domain = hostName;
  };

  systemd.services.caddy.serviceConfig = {
    inherit (config.systemd.services.duckdns.serviceConfig) EnvironmentFile;
  };

  services.caddy = {
    email = "danielphan.2003+acme@gmail.com";
    package = with pkgs; caddy.override {
      plugins = [ "github.com/caddy-dns/duckdns" ];
      buildGoModule = args:
        buildGoModule (removeAttrs args [ "vendorSha256" ] // {
          vendorSha256 = "sha256-cdLj9WQH8Ksii5xvo8VS6Nsj5+Xj4B1Nsh/IpjOYT+Q=";
        });
    };
    virtualHosts."*.${domain}" = {
      serverAliases = [ domain ];
      extraConfig = ''
        import common
        import logging ${domain}

        tls {
          dns duckdns {env.DUCKDNS_GMAIL} {
            override_domain ${hostName}
          }
        }
      '';
    };
  };

  nix.maxJobs = 4;

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";
  console.keyMap = "us";

  boot = {
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

    initrd.supportedFilesystems = [ "btrfs" ];

    kernelModules = config.boot.initrd.availableKernelModules;

    supportedFilesystems = [ "btrfs" "ntfs" ];

    persistence.path = "/persist";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/persist" ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/persist" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };
  };

  swapDevices =
    [{
      device = "/dev/disk/by-partuuid/3044b508-d0b4-44f7-adb5-cfb10080e8df";
      randomEncryption.enable = true;
    }];
}
