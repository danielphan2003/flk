{ pkgs, ... }: {
  home.packages = builtins.attrValues
    (if (builtins.elem pkgs.system pkgs.microsoft-edge-beta.meta.platforms)
    then
      {
        inherit (pkgs)
          microsoft-edge-beta
          ;
      }
    else { });
}
