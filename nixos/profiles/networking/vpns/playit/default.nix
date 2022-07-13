{
  config,
  pkgs,
  ...
}: {
  environment.persistence."${config.boot.persistence.path}".directories = ["/var/lib/playit-agent"];

  systemd.services.playit-agent = {
    enable = true;

    description = "playit.gg makes it possible to host game servers at home without port forwarding";

    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${pkgs.playit-agent}/bin/agent";
      Restart = "always";
      User = "playit";
      WorkingDirectory = "/var/lib/playit-agent";
      # Hardening
      CapabilityBoundingSet = [""];
      DeviceAllow = [""];
      LockPersonality = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
  };

  users.users.playit = {
    description = "playit.gg user";
    home = "/var/lib/playit-agent";
    createHome = true;
    isSystemUser = true;
    group = "playit";
  };
  users.groups.playit = {};
}
