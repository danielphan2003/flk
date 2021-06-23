{ lib, config, ... }:
let
  inherit (lib.our) appendString;
  inherit (lib.our.persistence) mkEtcPersist mkTmpfilesPersist;
  persistPath = config.boot.persistence.path;
in
{
  boot.persistence = {
    enable = true;
    path = "/persist";
  };
  
  environment.etc = mkEtcPersist {
    inherit persistPath;
    paths = [
      "adjtime"
      "machine-id"
      "nixos"
      "ssh/ssh_host_ed25519_key"
      "ssh/ssh_host_ed25519_key.pub"
      "ssh/ssh_host_rsa_key"
      "ssh/ssh_host_rsa_key.pub"
      "xdg/gtk-3.0/settings.ini"
      "NetworkManager/system-connections"
    ];
  };

  systemd.tmpfiles.rules = mkTmpfilesPersist {
    inherit persistPath;
    paths = appendString "/var/lib/" [
      "docker"
      "teamviewer"
      "NetworkManager/secret_key"
      "NetworkManager/seen-bssids"
      "NetworkManager/timestamps"
      "NetworkManager/NetworkManager.state"
    ];
  };

  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "${persistPath}/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "${persistPath}/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  services.btrfs.autoScrub.fileSystems = [ persistPath ];

  fileSystems."${persistPath}" = {
    device = "/dev/mapper/system";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };
}