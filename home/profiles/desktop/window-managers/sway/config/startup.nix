{pkgs, ...}: let
  clipboard-daemon = pkgs.callPackage ../scripts/clipboard-daemon.nix {};
  import-gsettings = pkgs.callPackage ../scripts/import-gsettings.nix {};
in
{
  wayland.windowManager.sway.config.startup = [
    {command = "${pkgs.autotiling}/bin/autotiling";}
    {command = "${clipboard-daemon}";}
    {
      command = "${import-gsettings}";
      always = true;
    }
    {command = "${pkgs.coreutils}/bin/mkfifo $$SWAYSOCK.wob && ${pkgs.coreutils}/bin/tail -f $$SWAYSOCK.wob | ${pkgs.wob}/bin/wob";}
    {
      command = "${pkgs.flameshot}/bin/flameshot";
      always = true;
    }
    {
      command = "[ $(${pkgs.ibus}/bin/ibus restart && exit) ] || ${pkgs.ibus}/bin/ibus-daemon -drx";
      always = true;
    }
    {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}
  ];
}
