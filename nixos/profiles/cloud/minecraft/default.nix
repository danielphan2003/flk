{ pkgs, lib, ... }: {
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

    whitelist = {
      harolddan2003 = "6973ee58-4347-4a8e-a9b4-e93ae85a6584";
    };

    jvmOpts = lib.concatStringsSep " " [
      "-Xmx1024M"
      "-Xms1024M"
      "-XX:+UseG1GC"
      "-XX:+CMSIncrementalPacing"
      "-XX:+CMSClassUnloadingEnabled"
      "-XX:ParallelGCThreads=2"
      "-XX:MinHeapFreeRatio=5"
      "-XX:MaxHeapFreeRatio=10"
    ];
  };
}
