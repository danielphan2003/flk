{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals;
  inherit (config.boot.persistence) path;
in {
  environment.systemPackages = builtins.attrValues {inherit (pkgs) fs-diff;};

  boot.persistence.enable = true;

  programs.fuse.userAllowOther = true;

  environment.etc."nixos".source = "/persist/etc/nixos";

  environment.persistence."${path}" = with config; {
    directories =
      []
      ++ [
        "/etc/ssh"
        "/var/lib/systemd/coredump"
      ]
      ++ optionals hardware.bluetooth.enable ["/var/lib/bluetooth"]
      ++ optionals networking.networkmanager.enable ["/etc/NetworkManager/system-connections"]
      ++ optionals networking.wireless.iwd.enable ["/var/lib/iwd"]
      ++ optionals services.adguardhome.enable ["/var/lib/private/AdGuardHome"]
      ++ optionals services.vaultwarden.enable [
        {
          directory = "/var/lib/bitwarden_rs";
          user = "vaultwarden";
          group = "vaultwarden";
        }
      ]
      ++ optionals services.calibre-server.enable [
        {
          directory = "/var/lib/calibre-server";
          inherit (services.calibre-server) user group;
        }
      ]
      ++ (with services.calibre-web;
        optionals
        enable
        ([
            {
              directory = "/var/lib/${dataDir}";
              inherit user group;
            }
          ]
          ++ optionals
          (options.calibreLibrary != null)
          [
            {
              directory = options.calibreLibrary;
              inherit user group;
            }
          ]))
      ++ optionals services.caddy.enable [
        {
          directory = services.caddy.dataDir;
          inherit (services.caddy) user group;
        }
      ]
      ++ optionals services.chrony.enable [
        {
          directory = services.chrony.directory;
          user = "chrony";
          group = "chrony";
        }
      ]
      ++ optionals services.dnscrypt-proxy2.enable ["/var/lib/private/dnscrypt-proxy2" "/var/cache/private/dnscrypt-proxy2"]
      ++ optionals services.fail2ban.enable ["/var/lib/fail2ban"]
      ++ optionals services.jicofo.enable ["/var/lib/jicofo"]
      ++ optionals services.jibri.enable [users.users.jibri.home]
      ++ optionals services.jitsi-meet.enable ["/var/lib/jitsi-meet"]
      ++ optionals (services.matrix-appservices.services != {}) (map (x: "/var/lib/matrix-as-${x}") (builtins.attrNames services.matrix-appservices.services))
      ++ optionals services.matrix-conduit.enable ["/var/lib/private/matrix-conduit"]
      ++ optionals services.mxisd.enable [services.mxisd.dataDir]
      ++ optionals services.prosody.enable ["/var/lib/prosody"]
      ++ optionals services.minecraft-server.enable [services.minecraft-server.dataDir]
      ++ optionals services.netdata.enable ["/var/lib/netdata" "/var/cache/netdata"]
      ++ optionals services.postgresql.enable ["/var/lib/postgresql"]
      ++ optionals services.postgresqlBackup.enable ["/var/backup/postgresql"]
      ++ optionals
      services.qbittorrent.enable
      [
        "/var/lib/qbittorrent/.config/qBittorrent/config"
        "/var/lib/qbittorrent/.config/qBittorrent/data"
      ]
      ++ optionals services.rss-bridge.enable [services.rss-bridge.dataDir]
      ++ optionals services.spotifyd.enable [services.spotifyd.settings.global.cache_path]
      ++ optionals services.tailscale.enable ["/var/lib/tailscale"]
      ++ optionals services.teamviewer.enable ["/var/lib/teamviewer"]
      ++ optionals services.timesyncd.enable ["/var/lib/systemd/timesync"]
      ++ optionals
      services.xserver.displayManager.sddm.enable
      ["/var/lib/sddm"]
      ++ optionals services.zerotierone.enable ["/var/lib/zerotier-one"]
      ++ optionals virtualisation.anbox.enable ["/var/lib/anbox"]
      ++ optionals virtualisation.docker.enable ["/var/lib/docker"]
      ++ optionals virtualisation.libvirtd.enable ["/var/lib/libvirt"]
      ++ optionals virtualisation.waydroid.enable ["/var/lib/waydroid" "/var/lib/misc"];

    files =
      []
      ++ [
        "/etc/machine-id"
        "/root/.local/share/nix/trusted-settings.json"
      ]
      ++ optionals (!environment.etc ? "xdg/gtk-3.0/settings.ini") ["/etc/xdg/gtk-3.0/settings.ini"];
  };

  fileSystems."/etc/ssh" = {
    depends = [path];
    neededForBoot = true;
  };

  fileSystems."${path}".neededForBoot = true;
}
