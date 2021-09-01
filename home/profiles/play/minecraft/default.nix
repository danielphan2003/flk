{ pkgs, ... }:
let
  mods = builtins.attrValues {
    inherit (pkgs.minecraft-mods)
      # both
      fabric-api
      ferrite-core
      lazydfu
      starlight

      # client
      better-bed
      cull-leaves
      sodium
      ;
  };
  modDir = pkgs.symlinkJoin {
    name = "minecraft-client-mods";
    paths = mods;
  };
in
{
  home.file.".local/share/multimc/mods" = {
    source = "${modDir}/share/java";
    recursive = true;
  };
}