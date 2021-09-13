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

  programs.fuse.userAllowOther = true;

  environment.etc."nixos".source = "/persist/etc/nixos";

  environment.persistence."${path}" = {
    directories = with config; [
      "/etc/ssh"
      "/var/lib/systemd/coredump"
    ]
    ++ optionals hardware.bluetooth.enable [ "/var/lib/bluetooth" ]
    ++ optionals networking.networkmanager.enable [ "/etc/NetworkManager/system-connections" ]
    ++ optionals services.adguardhome.enable [ "/var/lib/private/AdGuardHome" ]
    ++ optionals services.bitwarden_rs.enable [ "/var/lib/bitwarden_rs" ]
    ++ optionals services.caddy.enable [ services.caddy.dataDir ]
    ++ optionals services.chrony.enable [ services.chrony.directory ]
    ++ optionals services.fail2ban.enable [ "/var/lib/fail2ban" ]
    ++ optionals services.hercules-ci-agent.enable [ "/var/lib/hercules-ci-agent" ]
    ++ optionals services.minecraft-server.enable [ "/var/lib/minecraft" ]
    ++ optionals services.netdata.enable [ "/var/lib/netdata" "/var/cache/netdata" ]
    ++ optionals services.postgresql.enable [ "/var/lib/postgresql" ]
    ++ optionals services.postgresqlBackup.enable [ "/var/backup/postgresql" ]
    ++ optionals
      services.qbittorrent.enable
      [
        "/var/lib/qbittorrent/.config/qBittorrent/config"
        "/var/lib/qbittorrent/.config/qBittorrent/data"
      ]
    ++ optionals services.tailscale.enable [ "/var/lib/tailscale" ]
    ++ optionals services.teamviewer.enable [ "/var/lib/teamviewer" ]
    ++ optionals services.timesyncd.enable [ "/var/lib/systemd/timesync" ]
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
      "/root/.local/share/nix/trusted-settings.json"
    ];
  };

  fileSystems."/etc/ssh" = {
    depends = [ path ];
    neededForBoot = true;
  };

  fileSystems."${path}".neededForBoot = true;
}
