{ pkgs, lib, suites, config, self, ... }:
let
  inherit (lib) toUpper;
  inherit (builtins) attrValues toString;
  inherit (config.networking) domain hostName;

  ip = "192.168.1.2";
in
{
  imports = suites.pik2;

  age.secrets.duckdns.file = "${self}/secrets/nixos/profiles/cloud/duckdns.age";

  systemd.network.networks."budstick-home-wired".address = [ "${ip}/24" ];

  networking = {
    domain = "${hostName}.duckdns.org";
    usePredictableInterfaceNames = false;
    wireless.enable = false;
    firewall.allowedTCPPorts = [ 53 80 443 ];
  };

  services.openssh.openFirewall = true;

  services.duckdns = {
    enable = true;
    domain = hostName;
  };

  systemd.services.caddy = {
    serviceConfig.EnvironmentFile = "/run/secrets/duckdns";
  };

  services.caddy = {
    email = "danielphan.2003+acme@gmail.com";
    package = pkgs.caddy.override {
      plugins = [ "github.com/caddy-dns/duckdns" ];
      vendorSha256 = "sha256-deUq+/6EaevJOKm4AANIS8sPEHSRTQm7XlEkXONiJ84=";
    };
    config = lib.mkAfter ''
      *.${domain} {
        import common
        import logging ${domain}

        tls {
          dns duckdns {env.DUCKDNS_GMAIL} {
            override_domain ${hostName}
          }
        }
      }

      # *.${hostName} ${hostName} {
      #   import common
      #   import logging ${hostName}

      #   tls internal
      # }
    '';
  };

  nix.maxJobs = 4;

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";

  environment.systemPackages = attrValues {
    inherit (pkgs)
      raspberrypifw
      raspberrypi-eeprom
      libraspberrypi
      ;
  };

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
