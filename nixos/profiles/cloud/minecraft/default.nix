{ pkgs, lib, config, self, latestModulesPath, ... }:
let
  inherit (config.networking) hostName domain;
  inherit (config.uwu.tailscale) nameserver;
  inherit (config.services.minecraft-server.serverProperties) server-port;

  tld = "${domain}:${toString server-port}";
  tld-local = "${hostName}:${toString server-port}";
  tld-tailscale = "${nameserver}:${toString server-port}";

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
  imports = [ "${latestModulesPath}/services/web-servers/caddy/default.nix" ];
  disabledModules = [ "services/web-servers/caddy/default.nix" ];

  age.secrets = {
    minecraft-ops = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/ops.age";
    minecraft-whitelist = mkMcSecret "${self}/secrets/nixos/profiles/cloud/minecraft/whitelist.age";
  };

  environment.systemPackages = [ pkgs.fabric-installer ];

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
    package = pkgs.tuinitymc;

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

  services.caddy.virtualHosts."minecraft.${tld}" = {
    serverAliases = [
      "simp.${tld}"
      "simp.${tld-local}"
      "simp.${tld-tailscale}"
      "mc.${tld}"
      "mc.${tld-local}"
      "mc.${tld-tailscale}"
    ];
    extraConfig = ''
      reverse_proxy localhost:${toString server-port}
    '';
  };
}
