{
  pkgs,
  username,
  self,
  ...
}: let
  lock = pkgs.callPackage "${self}/home/profiles/desktop/window-managers/sway/scripts/lock.nix" {};
in [
  {
    name = "Lock screen";
    exec = lock;
    icon = ../icons/lock.svg;
  }
  {
    name = "Suspend";
    exec = "${lock}; systemctl suspend";
    icon = ../icons/suspend.svg;
  }
  {
    name = "Hibernate";
    exec = "${lock}; systemctl hibernate";
    icon = ../icons/hibernate.svg;
  }
  {
    name = "Logout";
    exec = "loginctl terminate-user ${username}";
    icon = ../icons/logout.svg;
  }
  {
    name = "Reboot";
    exec = "systemctl reboot";
    icon = ../icons/reboot.svg;
  }
  {
    name = "Shutdown";
    exec = "systemctl -i poweroff";
    icon = ../icons/shutdown.svg;
  }
]
