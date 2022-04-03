{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    if builtins.elem system jetbrains.idea-ultimate.meta.platforms
    then [jetbrains.idea-ultimate]
    else [];
}
