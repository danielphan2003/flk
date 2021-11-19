{ pkgs, ... }:
let
  mods = builtins.attrValues {
    inherit (pkgs.minecraft-mods)
      # both
      ferrite-core
      lazydfu
      starlight

      # client
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
  home.file.".local/share/ultimmc/mods" = {
    source = "${modDir}/share/java";
    recursive = true;
  };
  home.file.".local/share/ultimmc/lib/libglfw".source = "${pkgs.glfw}/lib";
}
