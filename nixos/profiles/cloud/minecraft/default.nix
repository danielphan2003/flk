{ pkgs, lib, self, ... }: {
  age.secrets.minecraft-whitelist = {
    file = "${self}/secrets/nixos/profiles/cloud/minecraft/whitelist.age";
    owner = "minecraft";
    group = "nogroup";
  };

  systemd.tmpfiles.rules = [
    "L /run/secrets/minecraft-whitelist - - - - /var/lib/minecraft/whitelist.json"
  ];

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
