{ pkgs, ... }: {
  programs.adb.enable =
    if pkgs.system == "aarch64-linux" then false else true;
}
