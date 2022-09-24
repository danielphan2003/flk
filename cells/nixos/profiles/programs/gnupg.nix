{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gnupg.agent = {
    enable = lib.mkDefault true;
    enableExtraSocket = true;
    pinentryFlavor = lib.mkDefault "curses";
  };
}
