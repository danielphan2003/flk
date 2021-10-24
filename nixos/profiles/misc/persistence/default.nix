{ config, lib, pkgs, ... }:
let
  inherit (lib) optionals;
  inherit (config.boot.persistence) path;
in
{
  environment.systemPackages = builtins.attrValues { inherit (pkgs) fs-diff; };

  boot.persistence.enable = true;

  programs.fuse.userAllowOther = true;

  environment.etc."nixos".source = "/persist/etc/nixos";

  environment.persistence."${path}" = with config; {
    directories = [ ]
      ++
      [
        "/etc/ssh"
        "/var/lib/systemd/coredump"
      ]
      ++ optionals hardware.bluetooth.enable [ "/var/lib/bluetooth" ]
      ++ optionals networking.networkmanager.enable [ "/etc/NetworkManager/system-connections" ]
      ++ optionals services.adguardhome.enable [ "/var/lib/private/AdGuardHome" ]
      ++ optionals services.vaultwarden.enable [ "/var/lib/bitwarden_rs" ]
      ++ optionals services.calibre-server.enable [ "/var/lib/calibre-server" ]
      ++ optionals services.calibre-web.enable [ "/var/lib/${services.calibre-web.dataDir}" ]
      ++ optionals services.caddy.enable [ services.caddy.dataDir ]
      ++ optionals services.chrony.enable [ services.chrony.directory ]
      ++ optionals services.dnscrypt-proxy2.enable [ "/var/lib/private/dnscrypt-proxy2" "/var/cache/private/dnscrypt-proxy2" ]
      ++ optionals services.fail2ban.enable [ "/var/lib/fail2ban" ]
      ++ optionals services.hercules-ci-agent.enable [ "/var/lib/hercules-ci-agent" ]
      ++ optionals services.minecraft-server.enable [ services.minecraft-server.dataDir ]
      ++ optionals services.netdata.enable [ "/var/lib/netdata" "/var/cache/netdata" ]
      ++ optionals services.postgresql.enable [ "/var/lib/postgresql" ]
      ++ optionals services.postgresqlBackup.enable [ "/var/backup/postgresql" ]
      ++ optionals
        services.qbittorrent.enable
        [
          "/var/lib/qbittorrent/.config/qBittorrent/config"
          "/var/lib/qbittorrent/.config/qBittorrent/data"
        ]
      ++ optionals services.spotifyd.enable [ services.spotifyd.settings.global.cache_path ]
      ++ optionals services.tailscale.enable [ "/var/lib/tailscale" ]
      ++ optionals services.teamviewer.enable [ "/var/lib/teamviewer" ]
      ++ optionals services.timesyncd.enable [ "/var/lib/systemd/timesync" ]
      ++ optionals
        services.xserver.displayManager.sddm.enable
        [ "/var/lib/sddm" ]
      ++ optionals virtualisation.anbox.enable [ "/var/lib/anbox" ]
      ++ optionals virtualisation.docker.enable [ "/var/lib/docker" ]
      ++ optionals virtualisation.libvirtd.enable [ "/var/lib/libvirt" ]
      ++ optionals virtualisation.waydroid.enable [ "/var/lib/waydroid" ]
    ;

    files = [ ]
      ++
      [
        "/etc/machine-id"
        "/root/.local/share/nix/trusted-settings.json"
      ]
      ++ optionals (environment.etc ? "xdg/gtk-3.0/settings.ini") [ "/etc/xdg/gtk-3.0/settings.ini" ];
  };

  fileSystems."/etc/ssh" = {
    depends = [ path ];
    neededForBoot = true;
  };

  fileSystems."${path}".neededForBoot = true;
}
