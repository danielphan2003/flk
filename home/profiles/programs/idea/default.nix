{
  pkgs,
  lib,
  ...
}: {
  home.packages =
    if builtins.elem pkgs.system pkgs.jetbrains.idea-ultimate.meta.platforms
    then [pkgs.jetbrains.idea-ultimate]
    else [];
}
