{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.eww;
in {
  options = {
    services.eww = {
      enable = mkEnableOption ''
        If enabled, start the eww daemon. Once enabled, eww will
        be able to display defined bars.
      '';
      package = mkOption {
        type = with types; package;
        default = pkgs.eww;
        defaultText = literalExample "${pkgs.eww-wayland}";
        description = ''
          eww package to use.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.eww" pkgs
        lib.platforms.linux)
    ];

    home.packages = [cfg.package];

    systemd.user.services.eww = {
      Unit = {
        Description = "a bar display";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        ExecPreStart = "${pkgs.coreutils}/bin/mkfifo /tmp/ewwpipe";
        ExecStart = "${cfg.package}/bin/eww --no-daemonize daemon";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
