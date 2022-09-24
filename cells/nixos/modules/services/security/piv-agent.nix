# Global configuration for piv-agent.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.piv-agent;
  gnupgCfg = config.programs.gnupg;

  # reuse the pinentryFlavor option from the gnupg module
  pinentryFlavor = config.programs.gnupg.agent.pinentryFlavor;
in {
  ###### interface

  options = {
    services.piv-agent = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start piv-agent when you log in.  Also sets
          SSH_AUTH_SOCK to point at piv-agent.

          Note that piv-agent will use whatever pinentry is
          specified in programs.gnupg.agent.pinentryFlavor.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.piv-agent;
        defaultText = literalExpression "pkgs.piv-agent";
        description = ''
          The package used for the piv-agent daemon.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !gnupgCfg.agent.enable;
        message = "You can't use piv-agent and GnuPG agent at the same time!";
      }
    ];

    environment.systemPackages = [cfg.package gnupgCfg.package];

    services.dbus.packages = mkIf (gnupgCfg.agent.pinentryFlavor == "gnome3") [pkgs.gcr];

    systemd.user.sockets.piv-agent = {
      description = "piv-agent socket activation";
      listenStreams = ["%t/piv-agent/ssh.socket" "%t/gnupg/S.gpg-agent"];
      wantedBy = ["sockets.target"];
    };

    systemd.user.services.piv-agent = mkMerge [
      {
        description = "piv-agent service";
        serviceConfig.ExecStart = "${cfg.package}/bin/piv-agent serve";
      }
      (mkIf (pinentryFlavor != null) {
        path = [pkgs.pinentry.${pinentryFlavor}];
        # wantedBy = [
        #   (if pinentryFlavor == "tty" || pinentryFlavor == "curses" then
        #     "default.target"
        #   else
        #     "graphical-session.target")
        # ];
      })
    ];

    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/piv-agent/ssh.sock"
      fi
    '';
  };
}
