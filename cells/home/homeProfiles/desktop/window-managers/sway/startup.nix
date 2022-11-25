{pkgs, ...}: let
  clipboard-daemon = pkgs.callPackage ./scripts/clipboard-daemon.nix {};
in {
  wayland.windowManager.sway.config.startup = [
    {
      command = "${pkgs.alacritty}/bin/alacritty";
      always = true;
    }
    {command = "${pkgs.autotiling}/bin/autotiling";}
    {command = "${clipboard-daemon}";}
    {
      command = "$(${pkgs.procps}/bin/pkill -u $USER swhks || true) && ${pkgs.swhkd}/bin/swhks";
      always = true;
    }
    {
      command = "${pkgs.import-gsettings}/bin/import-gsettings";
      always = true;
    }
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
