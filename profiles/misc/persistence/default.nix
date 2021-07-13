{ lib, config, latestModulesPath, ... }:
let inherit (config.boot.persistence) path; in
{
  boot.persistence = {
    enable = true;
    path = "/persist";
  };

  environment.persistence."${path}" = {
    directories = [
      "/etc/nixos"
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/hercules-ci-agent"
      "/var/lib/systemd/coredump"
      "/var/lib/teamviewer"
    ];

    files = [
      "/etc/machine-id"
      "/etc/xdg/gtk-3.0/settings.ini"
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - ${path}/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - ${path}/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - ${path}/var/lib/NetworkManager/timestamps"
    "L /var/lib/NetworkManager/NetworkManager.state - - - - ${path}/var/lib/NetworkManager/NetworkManager.state"
  ];

  services.btrfs.autoScrub.fileSystems = [ path ];

  fileSystems."/etc/ssh" = {
    depends = [ path ];
    neededForBoot = true;
  };

  fileSystems."${path}" = {
    device = "/dev/mapper/system";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };
}