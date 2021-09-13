{ pkgs, lib, config, self, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (lib.our.hostConfigs.tailscale) nameserver;
  inherit (config.services.minecraft-server.serverProperties) server-port;

  tld = "${domain}";
  tld-local = "${hostName}";
  tld-tailscale = "${nameserver}";

  mkMcSecret = file: {
    inherit file;
    owner = "minecraft";
    group = "nogroup";
  };

  mcPkg = pkgs.writeShellScript "minecraft-server" (with config.services.minecraft-server; ''
    ${pkgs.coreutils}/bin/unlink /var/lib/minecraft/whitelist.json
    ln -s /run/secrets/minecraft-whitelist /var/lib/minecraft/whitelist.json
    ${package}/bin/minecraft-server ${jvmOpts} $@
  '');
in
{
  age.secrets = {
    minecraft-ops = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/ops.age";
    minecraft-whitelist = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/whitelist.age";
  };

  environment.systemPackages = [ pkgs.fabric-installer ];

  systemd.services.minecraft-server = {
    # start minecraft server on demand
    enable = false;
    serviceConfig = {
      ExecStart = lib.mkForce mcPkg;
    };
  };

  services.minecraft-server = {
    enable = true;
    declarative = true;
    openFirewall = true;
    eula = true;
    package = pkgs.tuinitymc;

    serverProperties = {
      server-port = 25565;

      # In the future, I wish to enable this. Right now, not so much.
      online-mode = false;

      difficulty = "easy";

      gamemode = "survival";

      # Yes, I have this many friends.
      max-players = 9;

      # Is there a fancier way to represent this?
      motd = "S I M P World!";

      # Using secrets for this is PITA, so disabling it helps with
      # technical debts.
      # Thanks to Tailscale, I can revoke access to my server at any time.
      white-list = false;

      # Apply whitelist to everyone online if I ever decided to enable white list.
      enforce-whitelist = true;

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

  # services.caddy.virtualHosts."minecraft.${tld}" = {
  #   serverAliases = [
  #     "simp.${tld}"
  #     # "simp.${tld-local}"
  #     # "simp.${tld-tailscale}"
  #     "mc.${tld}"
  #     # "mc.${tld-local}"
  #     # "mc.${tld-tailscale}"
  #   ];
  #   extraConfig = ''
  #     reverse_proxy localhost:${toString server-port}
  #   '';
  # };
}
