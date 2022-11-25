{pkgs, ...}: let
  lockCmd = "${pkgs.sway-physlock}/bin/sway-physlock";
in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = lockCmd;
      }
      {
        event = "lock";
        command = lockCmd;
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = lockCmd;
      }
    ];
  };
}
