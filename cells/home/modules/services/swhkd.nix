{
  config,
  lib,
  pkgs,
  nixosConfig,
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
in {
  options = {
    services.swhkd = {
      enable = mkEnableOption "swhkd hotkey daemon";

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
    xdg.configFile."swhkd/swhkdrc".text =
      concatStringsSep "\n" [keybindingsStr cfg.extraConfig];
  };
}
