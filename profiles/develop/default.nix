{ pkgs, lib, ... }:
let inherit (builtins) attrValues;
in
{
  imports = [
    ./android
    ./python
  ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      aria2
      bc
      clang
      cmake
      du-dust
      file
      gdb
      git-crypt
      htop
      lazygit
      less
      lldb
      ncdu
      rsync
      tig
      tokei
      rnix-lsp
      ;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = attrValues {
      inherit (pkgs)
        font-awesome
        inter
        meslo-lgs-nf
        nerdfonts
        otf-apple
        twitter-color-emoji
        ;
    };
    fontconfig.enable = lib.mkForce true;
    fontconfig.defaultFonts = {
      emoji = [ "Font Awesome 5 Free" ];
      monospace = [ "Iosevka Nerd Font" ];
      serif = [ "New York Medium" ];
      sansSerif = [ "SF Pro Text" ];
    };
  };

  documentation.dev.enable = true;

  services.aria2 = {
    enable = true;
    # do not set this to your home directory.
    # apparently aria2 create tmpfiles based on downloadDir with root:root, so doing so would result in something like this:
    # "Detected unsafe path transition /home/${user} → /home/${user}/dl during canonicalization of /home/${user}/dl."
    downloadDir = "/var/lib/aria2/Downloads";
    extraArguments = "--check-certificate=false";
  };

  users.users.aria2.extraGroups = [ "users" ];

  services.cron.enable = true;

  programs.thefuck.enable = true;
  programs.firejail.enable = true;
  programs.mtr.enable = true;

}
