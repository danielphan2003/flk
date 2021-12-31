{ pkgs, ... }:
let
  mods-1_17_1 = builtins.attrValues {
    inherit (pkgs.minecraft-mods)
      # both
      ferritecore-1_17_1
      lazydfu
      starlight-fabric-1_17

      # client
      cull-leaves-1_17
      # sodium
      ;
  };

  mods-1_18_1 = builtins.attrValues {
    inherit (pkgs.minecraft-mods)
      # both
      ferritecore-1_18
      lazydfu
      starlight-fabric-1_18

      # client
      cull-leaves-1_17
      # sodium
      ;
  };

  modDir-1_17_1 =
    let
      mcVer = "1.17.1";
    in
    pkgs.symlinkJoin {
      name = "minecraft-client-mods-${mcVer}";
      paths = mods-1_17_1;
      passthru.mcVer = mcVer;
    };

  modDir-1_18_1 =
    let
      mcVer = "1.18.1";
    in
    pkgs.symlinkJoin {
      name = "minecraft-client-mods-${mcVer}";
      paths = mods-1_18_1;
      passthru.mcVer = mcVer;
    };
in
{
  home.file.".local/share/ultimmc/mods/${modDir-1_17_1.mcVer}" = {
    source = "${modDir-1_17_1}/share/java";
    recursive = true;
  };

  home.file.".local/share/ultimmc/mods/${modDir-1_18_1.mcVer}" = {
    source = "${modDir-1_18_1}/share/java";
    recursive = true;
  };

  home.file.".local/share/ultimmc/lib/libglfw".source = "${pkgs.glfw-wayland}/lib";
}
