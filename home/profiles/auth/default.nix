{ lib, pkgs, ... }: {

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 68400;
    enableSshSupport = true;
    enableExtraSocket = true;
    maxCacheTtl = 68400;
    pinentryFlavor = lib.mkDefault "curses";
  };

  programs.gpg.enable = true;

}
