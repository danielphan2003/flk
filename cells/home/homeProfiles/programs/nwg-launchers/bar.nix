{
  self,
  config,
  pkgs,
  ...
}: let
  lock = "${pkgs.sway-physlock}/bin/sway-physlock";

  bar = [
    {
      name = "Lock screen";
      exec = lock;
      icon = ./bar/icons/lock.svg;
    }
    {
      name = "Suspend";
      exec = "${lock}; systemctl suspend";
      icon = ./bar/icons/suspend.svg;
    }
    {
      name = "Hibernate";
      exec = "${lock}; systemctl hibernate";
      icon = ./bar/icons/hibernate.svg;
    }
    {
      name = "Logout";
      exec = "loginctl terminate-user ${config.home.username}";
      icon = ./bar/icons/logout.svg;
    }
    {
      name = "Reboot";
      exec = "systemctl reboot";
      icon = ./bar/icons/reboot.svg;
    }
    {
      name = "Shutdown";
      exec = "systemctl -i poweroff";
      icon = ./bar/icons/shutdown.svg;
    }
  ];
in {
  xdg.configFile."nwg-launchers/nwgbar/bar.json".text = builtins.toJSON bar;
  xdg.configFile."nwg-launchers/nwgbar/style.css".source = ./bar/style.css;
}
