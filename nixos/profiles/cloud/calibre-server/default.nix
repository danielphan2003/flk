{ config, pkgs, lib, self, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) tailnet_alias;
  inherit (lib.our.hostConfigs.hosts."${hostName}") tailscale_ip;

  inherit (config.services.calibre-server) libraries user group;
  inherit (config.users.users."${user}") home;

  tailnet-domain = "${hostName}.${tailnet_alias}";
  addr = tailscale_ip;
  port = 2753;
  prefix = "/calibre";

  calibre-server-userdb-age-key = "${self}/secrets/nixos/profiles/cloud/calibre-server/users.sqlite.age";

  calibre-server = pkgs.writeShellScriptBin "calibre-server" ''
    ${pkgs.coreutils}/bin/mkdir -p ${lib.concatStringsSep " " libraries}

    ${pkgs.calibre}/bin/calibre-server ${lib.concatStringsSep " " libraries} \
      --disable-log-not-found \
      --disable-use-bonjour \
      --disable-fallback-to-detected-interface \
      --max-jobs 2 \
      --url-prefix ${prefix} \
      --listen-on ${addr} \
      --port ${toString port} \
      --userdb ${config.age.secrets.calibre-server-userdb.path}
      --enable-auth \
      --auth-mode basic
  '';
in
{
  age.secrets.calibre-server-userdb = {
    file = calibre-server-userdb-age-key;
    path = "/run/secrets/calibre-server/users.sqlite";
    owner = user;
    inherit group;
  };

  services.calibre-server = {
    enable = true;
    libraries = [ "${home}/${hostName}" ];
  };

  networking.firewall.allowedTCPPorts = [ port ];

  systemd.services.calibre-server = {
    serviceConfig = {
      WorkingDirectory = home;
      RuntimeDirectory = user;
      RuntimeDirectoryMode = "0755";
      ExecStart = lib.mkForce "${calibre-server}/bin/calibre-server";
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "full";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0027";
    };
  };

  services.caddy.virtualHosts."${tailnet-domain}".extraConfig = lib.mkAfter ''
    reverse_proxy /calibre* ${addr}:${toString port}
  '';
}
