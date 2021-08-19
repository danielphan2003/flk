{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get (core|community) [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
    nvfetcher-github = {
      writer = budUtils.writeBashWithPaths [ nvfetcher-bin coreutils git nixUnstable ];
      synopsis = "nvfetcher-github";
      help = "Auto update with nvfetcher on github action";
      script = ./nvfetcher-github.bash;
    };
  };
}
