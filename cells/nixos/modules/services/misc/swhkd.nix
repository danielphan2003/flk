{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.swhkd;

  keybindingsStr = concatStringsSep "\n" (mapAttrsToList (hotkey: command:
    optionalString (command != null) ''
      ${hotkey}
        ${command}
    '')
  cfg.keybindings);

  configStr = concatStringsSep "\n" [keybindingsStr cfg.extraConfig];

  devicesStr = concatMapStringsSep " " (x: "--device ${x}") (cfg.devices or []);

  configFile = pkgs.writeText "swhkdrc" configStr;
in {
  options = {
    services.swhkd = {
      enable = mkEnableOption "swhkd";

      package = mkOption {
        type = types.package;
        default = pkgs.swhkd;
        description = ''
          swhkd package to use
        '';
      };

      keybindings = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
        description = "An attribute set that assigns hotkeys to commands.";
        example = literalExpression ''
          {
            "super + shift + {r,c}" = "i3-msg {restart,reload}";
            "super + {s,w}"         = "i3-msg {stacking,tabbed}";
          }
        '';
      };

      cooldown = mkOption {
        type = types.int;
        default = 250;
        description = ''
          Set a custom repeat cooldown duration. Default is 250ms. Most wayland compositors handle this server side however, either way works.
        '';
      };

      debug = mkEnableOption "swhkd debug mode";

      devices = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          Set the keyboard devices to use.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = "Additional configuration to add.";
        example = literalExpression ''
          super + {_,shift +} {1-9,0}
            i3-msg {workspace,move container to workspace} {1-10}
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    environment.etc."swhkd/swhkdrc".source = configFile;

    systemd.user.services.swhkd = {
      description = "swhkd hotkey daemon";

      bindsTo = ["default.target"];

      script = ''
        /run/wrappers/bin/pkexec ${cfg.package}/bin/swhkd \
          --config /etc/swhkd/swhkdrc \
          --cooldown ${toString cfg.cooldown} \
          ${optionalString (cfg.devices != null) devicesStr} \
          ${optionalString cfg.debug "--debug"}
      '';

      restartTriggers = [configFile];

      serviceConfig.Restart = "always";

      wantedBy = ["default.target"];
    };

    systemd.user.services.swhks = {
      description = "swhkd hotkey server";

      after = ["swhkd.service"];

      partOf = ["swhkd.service"];

      preStart = "${pkgs.psmisc}/bin/killall swhks &>/dev/null || ${pkgs.coreutils}/bin/true";

      script = ''
        export SWAYSOCK="''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(${pkgs.procps}/bin/pgrep --uid $UID -x sway || true).sock"
        ${pkgs.swhkd}/bin/swhks &
      '';

      serviceConfig = {
        RemainAfterExit = true;
        KillMode = "process";
        Restart = "always";
        Type = "forking";
      };

      wantedBy = ["swhkd.service"];
    };
  };
}
