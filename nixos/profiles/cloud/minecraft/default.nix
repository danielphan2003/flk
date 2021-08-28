{ pkgs, lib, config, self, ... }:
let
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

  systemd.services.minecraft-server = {
    serviceConfig = {
      ExecStart = lib.mkForce mcPkg;
    };
  };

  services.minecraft-server = {
    enable = true;
    declarative = true;
    openFirewall = true;
    eula = true;
    package = pkgs.papermc;

    serverProperties = {
      server-port = 25565;
      online-mode = false;
      difficulty = "easy";
      gamemode = "survival";
      max-players = 9;
      motd = "S I M P World!";
      white-list = true;
      enforce-whitelist = true;
      enable-rcon = false;
      prevent-proxy-connections = true;
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
