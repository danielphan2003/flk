{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.avizo;
in {
  options = {
    services.avizo = {
      enable = mkEnableOption "Enable avizo volume notifier daemon";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [avizo];

    systemd.user.services.avizo = {
      Unit = {
        Description = "avizo volume notification";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.avizo}/bin/avizo-service";
      };

      Install = {WantedBy = ["graphical-session.target"];};
    };
  };
}
