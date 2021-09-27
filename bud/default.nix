{ pkgs, lib, budUtils, ... }:
let
  writeBashWithNixPaths = paths: name: script:
    pkgs.writers.writeBash name ''
      export PATH="${lib.makeBinPath paths}"
      export NIX_PATH="$NIX_PATH:nixpkgs=${toString pkgs.path}"
      source ${script}
    '';
in
{
  bud.cmds = with pkgs; {
    get = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "get (core|community) [DEST]";
      help = "Copy the desired template to DEST";
      script = ./get.bash;
    };
  };
}
