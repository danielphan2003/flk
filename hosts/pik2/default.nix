{ suites, pkgs, config, lib, hardware, self, ... }:
let
  inherit (builtins) attrValues toString;
  inherit (lib) concatMapStrings mkAfter toUpper;
  ip = "192.168.1.2";
  hostname = "pik2";
  persistPath = "/persist";
  caddyTemplate = import ./caddy.nix;
in
{
  imports = suites.pik2;

  age.secrets = {
    duckdns.file = "${self}/secrets/duckdns.age";
    bitwarden.file = "${self}/secrets/bitwarden.age";
  };

  networking = {
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

  systemd.services.duckdns = {
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/run/secrets/duckdns";
    };
    script = ''
      IPV6="$(${pkgs.dnsutils}/bin/dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6 2>&1)"
      ${pkgs.curl}/bin/curl "https://www.duckdns.org/update?domains=${hostname}&token=''$${toUpper hostname}&ipv6=$IPV6&ip="
    '';
  };

  systemd.timers.duckdns = {
    wantedBy = [ "timers.target" ];
    partOf = [ "duckdns.service" ];
    timerConfig.OnCalendar = "*:0/15";
  };

  services.logrotate = {
    enable = false;
    paths = {
      bitwarden_rs = {
        path = "/var/log/bitwarden/*.log";
        # Perform logrotation as the bitwarden user and group
        user = "bitwarden_rs";
        group = "bitwarden_rs";
        # Rotate daily
        frequency = "daily";
        # Keep 4 rotations of log files before removing or mailing to the address specified in a mail directive
        extraConfig = ''
          # Rotate when the size is bigger than 5MB
          rotate 4
          size 5Ms
          # Compress old log files
          compress
          # Truncate the original log file in place after creating a copy
          copytruncate
          # Don't panic if not found
          missingok
          # Don't rotate log if file is empty
          notifempty
          # Add date instaed of number to rotated log file
          dateext
          # Date format of dateext
          dateformat "-%Y-%m-%d-%s"
        '';
      };
    };
  };

  services.bitwarden_rs = {
    enable = true;
    config = {
      domain = "https://bw.pik2.duckdns.org";
      invitationsAllowed = false;
      rocketPort = 8222;
      rocketLog = "critical";
      signupsAllowed = false;
      showPasswordHint = false;
      websocketEnabled = true;
      websocketPort = 3012;
      websocketAddress = "127.0.0.1";
      webVaultFolder = "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
      webVaultEnabled = true;
      dataFolder = "${persistPath}/var/lib/bitwarden_rs";
    };
    environmentFile = "/run/secrets/bitwarden";
    backupDir = "${persistPath}/backups/vault";
  };

  systemd.services.caddy = {
    serviceConfig.EnvironmentFile = "/run/secrets/duckdns";
  };

  services.caddy = {
    enable = true;
    email = "danielphan.2003+acme@gmail.com";
    config = with config.services; ''
      ${caddyTemplate}

      (tls-${hostname}) {
        import common
        tls {
          dns duckdns {env.${toUpper hostname}} {
            override_domain ${hostname}.duckdns.org
          }
        }
      }

      *.${hostname}.duckdns.org {
        import tls-${hostname}
        import logging ${hostname}

        @bw host bw.${hostname}.duckdns.org
        handle @bw {
          import reverseProxy 127.0.0.1:${toString bitwarden_rs.config.rocketPort}
          import NoSearchHeader

          # The negotiation endpoint is also proxied to Rocket
          reverse_proxy /notifications/hub/negotiate ${bitwarden_rs.config.websocketAddress}:${toString bitwarden_rs.config.rocketPort}

          # Notifications redirected to the websockets server
          reverse_proxy /notifications/hub ${bitwarden_rs.config.websocketAddress}:${toString bitwarden_rs.config.websocketPort}
        }

        @calibre host calibre.${hostname}.duckdns.org
        handle @calibre {
          import reverseProxy ${calibre-web.listen.ip}:${toString calibre-web.listen.port}
          import NoSearchHeader
        }

        @grafana host grafana.${hostname}.duckdns.org
        handle @grafana {
          import reverseProxy ${grafana.addr}:${toString grafana.port}
          import NoSearchHeader
        }

        # Fallback for otherwise unhandled domains
        handle {
          respond "404 Not Found! Or is it...?" 200
        }
      }
    '';
  };

  services.calibre-server = {
    enable = true;
    libraries = [ "/var/lib/calibre-library" ];
  };

  services.calibre-web = {
    enable = false;
    openFirewall = true;
    listen = {
      ip = "127.0.0.1";
      port = 8083;
    };
    options = {
      calibreLibrary = "/var/lib/calibre-library";
      enableBookUploading = true;
      enableBookConversion = true;
      reverseProxyAuth.enable = true;
    };
  };

  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/calibre-library - - - - ${persistPath}/var/lib/calibre-library"
    "L /var/lib/calibre-web/app.db - - - - ${persistPath}/var/lib/calibre-web/app.db"
    "L /var/lib/calibre-web/gdrive.db - - - - ${persistPath}/var/lib/calibre-web/gdrive.db"
    # "L /var/lib/bitwarden_rs - - - - ${persistPath}/var/lib/bitwarden_rs"
  ];

  nix.maxJobs = 4;

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Ho_Chi_Minh";

  environment.systemPackages = attrValues {
    inherit (pkgs)
      raspberrypifw
      raspberrypi-eeprom
      libraspberrypi
      picocom
      fanficfare
      ;
  };

  boot.initrd.availableKernelModules = [
    "pcie_brcmstb"
    "bcm_phy_lib"
    "broadcom"
    "mdio_bcm_unimac"
    "genet"
    "vc4"
    "bcm2835_dma"
    "i2c_bcm2835"
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "algif_skcipher"
    "xchacha20"
    "adiantum"
    "sha256"
    "nhpoly1305"
    "dm-crypt"
    "uas" # necessary for my UAS-enabled NVME-USB adapter
  ];
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  boot = {
    kernelModules = config.boot.initrd.availableKernelModules;
    supportedFilesystems = [ "btrfs" "ntfs" ];
  };

  services.btrfs.autoScrub.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices =
    [{
      device = "/dev/disk/by-partuuid/3044b508-d0b4-44f7-adb5-cfb10080e8df";
      randomEncryption.enable = true;
    }];
}
