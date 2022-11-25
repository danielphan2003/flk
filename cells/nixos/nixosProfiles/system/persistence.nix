{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault optional optionals;
  inherit (config.boot.persistence) path;
in {
  environment.systemPackages = [pkgs.fs-diff];

  boot.tmpOnTmpfs = mkDefault true;

  boot.persistence = {
    enable = true;
    path = mkDefault "/persist";
  };

  programs.fuse.userAllowOther = true;

  environment.persistence."${path}" = let
    inherit
      (config)
      environment
      hardware
      networking
      services
      virtualisation
      users
      ;
  in {
    directories =
      [
        "/etc/ssh"
        "/var/lib/systemd/coredump"
      ]
      ++ optional hardware.bluetooth.enable "/var/lib/bluetooth"
      ++ optional networking.networkmanager.enable "/etc/NetworkManager/system-connections"
      ++ optional networking.wireless.iwd.enable "/var/lib/iwd"
      ++ optional services.adguardhome.enable "/var/lib/private/AdGuardHome"
      ++ optional services.calibre-server.enable
      {
        directory = "/var/lib/calibre-server";
        inherit (services.calibre-server) user group;
      }
      ++ optional services.calibre-web.enable
      {
        directory = "/var/lib/${services.calibre-web.dataDir}";
        inherit (services.calibre-web) user group;
      }
      ++ optional (services.calibre-web.enable && services.calibre-web.options.calibreLibrary != null)
      {
        directory = services.calibre-web.options.calibreLibrary;
        inherit (services.calibre-web) user group;
      }
      ++ optional services.caddy.enable
      {
        directory = services.caddy.dataDir;
        inherit (services.caddy) user group;
      }
      ++ optional services.chrony.enable
      {
        directory = services.chrony.directory;
        user = "chrony";
        group = "chrony";
      }
      ++ optionals services.dnscrypt-proxy2.enable ["/var/lib/private/dnscrypt-proxy2" "/var/cache/private/dnscrypt-proxy2"]
      ++ optional services.etebase-server.enable
      rec {
        directory = services.etebase-server.dataDir;
        user = services.etebase-server.user;
        group = user;
      }
      ++ optional services.fail2ban.enable "/var/lib/fail2ban"
      ++ optional services.grafana.enable services.grafana.dataDir
      ++ optional services.jicofo.enable "/var/lib/jicofo"
      ++ optional services.jibri.enable users.users.jibri.home
      ++ optional services.jitsi-meet.enable "/var/lib/jitsi-meet"
      # ++ optionals (services.matrix-appservices.services != {}) (map (x: "/var/lib/matrix-as-${x}") (builtins.attrNames services.matrix-appservices.services))
      ++ optional services.matrix-conduit.enable "/var/lib/private/matrix-conduit"
      ++ optional services.mxisd.enable services.mxisd.dataDir
      ++ optional services.prosody.enable "/var/lib/prosody"
      ++ optional services.minecraft-server.enable services.minecraft-server.dataDir
      ++ optionals services.netdata.enable ["/var/lib/netdata" "/var/cache/netdata"]
      ++ optional services.postgresql.enable "/var/lib/postgresql"
      ++ optional services.postgresqlBackup.enable services.postgresqlBackup.location
      ++ optionals services.qbittorrent.enable
      [
        "/var/lib/qbittorrent/.config/qBittorrent/config"
        "/var/lib/qbittorrent/.config/qBittorrent/data"
      ]
      ++ optional services.rss-bridge.enable services.rss-bridge.dataDir
      ++ optional services.spotifyd.enable services.spotifyd.settings.global.cache_path
      ++ optional services.tailscale.enable "/var/lib/tailscale"
      ++ optional services.teamviewer.enable "/var/lib/teamviewer"
      ++ optional services.timesyncd.enable "/var/lib/systemd/timesync"
      ++ optional services.vaultwarden.enable
      {
        directory = "/var/lib/bitwarden_rs";
        user = "vaultwarden";
        group = "vaultwarden";
      }
      ++ optional services.xserver.displayManager.sddm.enable "/var/lib/sddm"
      ++ optional services.zerotierone.enable "/var/lib/zerotier-one"
      ++ optional virtualisation.anbox.enable "/var/lib/anbox"
      ++ optional virtualisation.docker.enable "/var/lib/docker"
      ++ optional virtualisation.libvirtd.enable "/var/lib/libvirt"
      ++ optionals virtualisation.waydroid.enable ["/var/lib/waydroid" "/var/lib/misc"];

    files =
      [
        "/etc/machine-id"
        "/root/.local/share/nix/trusted-settings.json"
      ]
      ++ optional (!environment.etc ? "xdg/gtk-3.0/settings.ini") "/etc/xdg/gtk-3.0/settings.ini";
  };

  fileSystems."/etc/ssh" = {
    depends = [path];
    neededForBoot = true;
  };

  fileSystems."${path}".neededForBoot = true;
}
