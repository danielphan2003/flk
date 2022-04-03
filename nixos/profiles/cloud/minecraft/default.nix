{
  self,
  config,
  hostConfigs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionalAttrs;
  inherit (hostConfigs.hosts."${config.networking.hostName}") tailscale_ip;

  inherit (config.services.minecraft-server) dataDir;
  inherit (config.services.minecraft-server.onDemand) proxyIp;
  inherit (config.services.minecraft-server.serverProperties) online-mode white-list;

  inherit (pkgs.formats.mc-motd) c f gen;

  mkMcSecret = file: path: {
    inherit file path;
    symlink = false;
    owner = "minecraft";
    group = "minecraft";
  };
in {
  assertions = [
    {
      assertion =
        (!config.services.tailscale.enable && white-list) || config.services.tailscale.enable;
      message = ''
        Minecraft servers should not be exposed to the Internet if
        A) the server is not accessible via a VPN like Tailscale and has not enabled whitelisting
        or B) the server *is* accessible via a VPN like Tailscale, so whitelisting doesn't matter.
      '';
    }
  ];

  age.secrets =
    {
      minecraft-ops = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/ops.age" "${dataDir}/ops.json";
    }
    // optionalAttrs (!online-mode && white-list) {
      minecraft-whitelist = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/whitelist.age" "${dataDir}/whitelist.json";
    };

  environment.systemPackages = [pkgs.fabric-installer];

  systemd.sockets.proxy-minecraft-server = lib.mkIf (proxyIp == tailscale_ip) {after = ["tailscaled.service"];};

  services.minecraft-server = {
    enable = true;
    declarative = true;
    openFirewall = true;
    eula = true;
    package = pkgs.papermc-1_17_1;

    onDemand = {
      enable = false;
      # idle after 1 minutes of inactivity
      # TuinityMC starts fast enough so users won't notice anything
      idleIfTime = 1 * 60;
      proxyIp = tailscale_ip;
      # Users will be able to access server with default port.
      proxyPort = 25565;
    };

    serverProperties = {
      # In the future, I wish to enable this. Right now, not so much.
      online-mode = false;

      difficulty = "easy";

      gamemode = "survival";

      # Yes, I have this many friends.
      max-players = 9;

      # Yes, dis is de way
      # see https://mctools.org/motd-creator?text=%262S+%263I+%26cM+%265P+%266W%267o%268r%269l%26ad%26b%21%0D%0A%266C%C3%A1c+pn+th%E1%BA%ADt+l%C3%A0+h%E1%BB%81+h%C6%B0%E1%BB%9Bc+qu%C3%A1+%E1%BA%A1k+%265%7C+%26cTr%E1%BB%9F+th%C3%A0nh+hecker+nk3+%26kpn
      # full text:
      #                                                 |
      #               ⟹ S I M P World! ⟸            |
      # Trở thành hecker nk3 pn | danielphan.2003#1147 |
      motd = with c;
        ""
        + "              "
        + (gen "${d_g}⟹ S ${d_a}I ${l_r}M ${d_p}P ${g}W${l_g}o${d_g}r${l_b}l${l_g}d${l_a}! ⟸")
        + "            "
        + ''\n''
        + (gen "${g}Trở thành hecker nk3 ${f.ob "pn"}${f.re ""} ${l_p}| ${l_b}danielphan.2003${l_g}#1147");

      # Using secrets for this is PITA, so disabling it helps with
      # technical debts.
      # Thanks to Tailscale, I can revoke access to my server at any time.
      white-list = false;

      # Apply whitelist to everyone online if I ever decided to enable white list.
      enforce-whitelist = true;

      server-ip = "127.0.0.1";

      # We want to start the actual server with another port so our on-demand server management mechanism can work as expected.
      # server-port = 25567;
      server-port = 25565;

      # I don't need access to the server terminal. This is not SAO: Fairy Dance.
      enable-rcon = false;

      # Don't even connect to my server via VPNs, unless you are using Tailscale, of course
      prevent-proxy-connections = true;

      # So I don't have to make everyone op
      spawn-protection = 0;

      # 5 minutes tick timeout, for heavy packs
      max-tick-time = 5 * 60 * 1000;
    };

    jvmOpts = lib.concatStringsSep " " [
      "-Xmx1024M"
      "-Xms1024M"
      "-XX:ParallelGCThreads=2"
      "-XX:MinHeapFreeRatio=5"
      "-XX:MaxHeapFreeRatio=10"
      "-Xlog:gc*:logs/gc.log:time,uptime:filecount=5,filesize=1M"
      "-XX:+UseG1GC"
      "-XX:+ParallelRefProcEnabled"
      "-XX:MaxGCPauseMillis=200"
      "-XX:+UnlockExperimentalVMOptions"
      "-XX:+DisableExplicitGC"
      "-XX:+AlwaysPreTouch"
      "-XX:G1NewSizePercent=30"
      "-XX:G1MaxNewSizePercent=40"
      "-XX:G1HeapRegionSize=8M"
      "-XX:G1ReservePercent=20"
      "-XX:G1HeapWastePercent=5"
      "-XX:G1MixedGCCountTarget=4"
      "-XX:InitiatingHeapOccupancyPercent=15"
      "-XX:G1MixedGCLiveThresholdPercent=90"
      "-XX:G1RSetUpdatingPauseTimePercent=5"
      "-XX:SurvivorRatio=32"
      "-XX:+PerfDisableSharedMem"
      "-XX:MaxTenuringThreshold=1"
    ];
  };
}
