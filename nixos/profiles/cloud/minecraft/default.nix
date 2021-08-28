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

  systemd.tmpfiles.rules = [
    "L+ /run/secrets/minecraft-ops - - - - /var/lib/minecraft/ops.json"
  ];

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
      "-XX:+UseG1GC"
      "-XX:ParallelGCThreads=2"
      "-XX:MinHeapFreeRatio=5"
      "-XX:MaxHeapFreeRatio=10"
    ];
  };
}
