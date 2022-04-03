{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.minecraft-server;

  inherit (cfg.onDemand) idleIfTime proxyPort proxyIp;

  # To be able to open the firewall, we need to read out port values in the
  # server properties, but fall back to the defaults when those don't exist.
  # These defaults are from https://minecraft.gamepedia.com/Server.properties#Java_Edition_3
  maxPlayers = cfg.serverProperties.max-players or 20;

  serverIp = cfg.serverProperties.server-ip or "127.0.0.1";

  serverPort = cfg.serverProperties.server-port or 25567;
in {
  options = {
    services.minecraft-server.onDemand = mkOption {
      type = with types;
        submodule {
          options = {
            enable = mkOption {
              type = bool;
              default = false;
              description = "Enable Minecraft Server Monitor daemon.";
            };
            idleIfTime = mkOption {
              type = int;
              default = 1 * 60;
              description = "Time in seconds. Idle the server if there is no player on it and this time is exceeded.";
            };
            proxyPort = mkOption {
              type = port;
              default = 25565;
              description = ''
                Port that players should connect to.
                Must be different from `serverProperties.server-port` if `onDemand.proxyIp` is the same as `serverProperties.server-ip`.
              '';
            };
            proxyIp = mkOption {
              type = nullOr str;
              default = "[::]";
              description = "Set a string to listen on specific IP. Default is all addresses";
            };
          };
        };
      description = ''
        A daemon that monitors the actual Minecraft server.
        If the server is up and there is no player, then daemon shuts the server down.
        If the server is down and there is an incoming connection, daemon starts the actual server.
        Otherwise, daemon does nothing.
      '';
    };
  };

  config = mkIf (cfg.enable && cfg.onDemand.enable) {
    # Chain of "requires"
    # proxy-minecraft-server -> minecraft-server
    # This means stopping any of one of them would stop everything on this chain.
    # And, most importantly, after stopping any of them (which means the whole chain stops), starting any of them except the head will not bring it up.
    # In other words, restarting anything except the head of this chain would stop the chain completely but not restart it.
    # Conclusion: to manually restart our service, one must restart proxy-minecraft-server.

    assertions = [
      {
        assertion = proxyPort != serverPort;
        message = ''
          The `onDemand.proxyPort` must not be the same as `serverProperties.server-port`
        '';
      }
    ];

    # We don't expose rcon and query port because we are unable to do so due to the PrivateNetwork setting
    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [proxyPort];
      allowedTCPPorts = [proxyPort];
    };

    systemd.services = {
      minecraft-server = {
        # If server management is disabled, multi-user.target wants this service always, so this configuration is sound.
        # If server management is enabled, the chain of "requires" is constructed, as intended.
        unitConfig.StopWhenUnneeded = true;

        serviceConfig = {
          # JVM exits 143 on SIGTERM after graceful shutdown, which is fine. See also: https://serverfault.com/questions/695849/services-remain-in-failed-state-after-stopped-with-systemctl
          SuccessExitStatus = 143;
          # Hardening. A Minecraft server doesn't need much.
          PrivateNetwork = true;
          PrivateTmp = true;
          # Users Database is not available for within the unit, only root and minecraft is available, everybody else is nobody
          PrivateUsers = true;
          # Read only mapping of /usr /boot and /etc
          ProtectSystem = "full";
          # /home, /root and /run/user seem to be empty from within the unit.
          ProtectHome = true;
          # /proc/sys, /sys, /proc/sysrq-trigger, /proc/latency_stats, /proc/acpi, /proc/timer_stats, /proc/fs and /proc/irq will be read-only within the unit.
          ProtectKernelTunables = true;
          # Block module system calls, also /usr/lib/modules.
          ProtectKernelModules = true;
          ProtectControlGroups = true;
        };

        # There will be no multiple instances, clean up the session lock to avoid successive startup failure.
        # Use -f flag so that there would be no failure if session.lock doesn't exist.
        postStop = "${pkgs.coreutils}/bin/rm -f ./*/session.lock";
      };

      # This service serves as a bi-directional relay between the actual server and systemd socket
      proxy-minecraft-server = {
        requires = ["minecraft-server.service" "proxy-minecraft-server.socket"];
        after = ["minecraft-server.service" "proxy-minecraft-server.socket"];

        # Share the same network namespace, so the network traffic could be reacheable.
        unitConfig.JoinsNamespaceOf = "minecraft-server.service";
        serviceConfig = {
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd ${serverIp}:${
            toString serverPort
          } -c ${toString maxPlayers} --exit-idle-time=${
            toString idleIfTime
          }";
          PrivateTmp = true;
          PrivateNetwork = true;
        };
      };
    };

    systemd.sockets.proxy-minecraft-server = {
      # Listen on proxyIp
      listenStreams = ["${proxyIp}:${toString proxyPort}"];
      # Start this socket on boot
      wantedBy = ["sockets.target"];
      # Don't start multiple instances of corresponding service.
      socketConfig.Accept = false;
    };
  };
}
