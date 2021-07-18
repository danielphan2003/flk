{ lib, config, latestModulesPath, ... }:
let
  inherit (lib) optionals;
  inherit (config.boot.persistence) path;
in
{
  imports = [
    "${latestModulesPath}/config/swap.nix"
    "${latestModulesPath}/misc/extra-arguments.nix"
    "${latestModulesPath}/tasks/filesystems.nix"
  ];

  disabledModules = [
    "config/swap.nix"
    "misc/extra-arguments.nix"
    "tasks/filesystems.nix"
  ];

  boot.persistence.enable = true;

  environment.persistence."${path}" = {
    directories = with config; [
      "/etc/nixos"
      "/etc/ssh"
      "/var/lib/systemd/coredump"
    ]
    ++ optionals hardware.bluetooth.enable [ "/var/lib/bluetooth" ]
    ++ optionals networking.networkmanager.enable [ "/etc/NetworkManager/system-connections" ]
    ++ optionals services.bitwarden_rs.enable [ "/var/lib/bitwarden_rs" ]
    ++ optionals services.fail2ban.enable [ "/var/lib/fail2ban" ]
    ++ optionals services.hercules-ci-agent.enable [ "/var/lib/hercules-ci-agent" ]
    ++ optionals services.postgresql.enable [ "/var/lib/postgresql" ]
    ++ optionals services.postgresqlBackup.enable [ "/var/backup/postgresql" ]
    ++ optionals
      services.qbittorrent.enable
      [
        "/var/lib/qbittorrent/.config/qBittorrent/config"
        "/var/lib/qbittorrent/.config/qBittorrent/data"
      ]
    ++ optionals services.teamviewer.enable [ "/var/lib/teamviewer" ]
    ++ optionals
      services.xserver.displayManager.sddm.enable
      [ "/var/lib/sddm" ]
    ++ optionals virtualisation.anbox.enable [ "/var/lib/anbox" ]
    ++ optionals virtualisation.docker.enable [ "/var/lib/docker" ]
    ++ optionals virtualisation.libvirtd.enable [ "/var/lib/libvirt" ]
    ;

    files = [
      "/etc/machine-id"
      "/etc/xdg/gtk-3.0/settings.ini"
    ];
  };

  systemd.tmpfiles.rules = with config; [ ]
    ++ optionals
    networking.networkmanager.enable
    [
      "L /var/lib/NetworkManager/secret_key - - - - ${path}/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - ${path}/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - ${path}/var/lib/NetworkManager/timestamps"
      "L /var/lib/NetworkManager/NetworkManager.state - - - - ${path}/var/lib/NetworkManager/NetworkManager.state"
    ]
  ;

  fileSystems."/etc/ssh" = {
    depends = [ path ];
    neededForBoot = true;
  };

  fileSystems."${path}".neededForBoot = true;
}
