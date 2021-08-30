{ pkgs, lib, suites, config, self, ... }:
let
  inherit (lib) toUpper;
  inherit (builtins) attrValues readFile toString;
  inherit (config.networking) domain hostName;

  ip = "192.168.1.2";

  caddyTemplate = readFile ./Caddyfile;

  mkAddr = addr: lib.concatStringsSep " " [
    # Public
    "${addr}.${domain}"

    # Private
    "${addr}.${hostName}"

    # (Optional) Shared
    "${addr}.${hostName}.danielphan-2003.gmail.com.beta.tailscale.net"
  ];
in
{
  imports = suites.pik2;

  age.secrets.duckdns.file = "${self}/secrets/nixos/profiles/cloud/duckdns.age";

  networking = {
    domain = "${hostName}.duckdns.org";
    usePredictableInterfaceNames = false;
    wireless.enable = false;
    useDHCP = false;
    interfaces."eth0".ipv4.addresses = [{
      address = ip;
      prefixLength = 16;
    }];
    defaultGateway = "192.168.1.1";
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
    enable = true;
    email = "danielphan.2003+acme@gmail.com";
    package = pkgs.caddy.override {
      plugins = [ "github.com/caddy-dns/duckdns" ];
      vendorSha256 = "sha256-deUq+/6EaevJOKm4AANIS8sPEHSRTQm7XlEkXONiJ84=";
    };
    config = with config.services; ''
      ${caddyTemplate}

      (tls-duckdns) {
        import common
        tls {
          dns duckdns {env.DUCKDNS_GMAIL} {
            override_domain ${duckdns.domain}
          }
        }
      }

      ${mkAddr "*"} {
        import tls-duckdns
        import logging ${hostName}

        @bw host ${mkAddr "bw"}
        handle @bw {
          import reverseProxy 127.0.0.1:${toString bitwarden_rs.config.rocketPort}
          import NoSearchHeader

          # The negotiation endpoint is also proxied to Rocket
          reverse_proxy /notifications/hub/negotiate ${bitwarden_rs.config.websocketAddress}:${toString bitwarden_rs.config.rocketPort}

          # Notifications redirected to the websockets server
          reverse_proxy /notifications/hub ${bitwarden_rs.config.websocketAddress}:${toString bitwarden_rs.config.websocketPort}
        }

        @calibre host ${mkAddr "calibre"}
        handle @calibre {
          import reverseProxy ${calibre-web.listen.ip}:${toString calibre-web.listen.port}
          import NoSearchHeader
        }

        @grafana host ${mkAddr "grafana"}
        handle @grafana {
          import reverseProxy ${grafana.addr}:${toString grafana.port}
          import NoSearchHeader
        }

        @minecraft host ${mkAddr "mc"}
        handle @minecraft {
          import reverseProxy 127.0.0.1:${toString minecraft-server.serverProperties.server-port}
          import NoSearchHeader
        }

        # Fallback for otherwise unhandled domains
        handle {
          respond "404 Not Found! Or is it...?" 200
        }
      }
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
