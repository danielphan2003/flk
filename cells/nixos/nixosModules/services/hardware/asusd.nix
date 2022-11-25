{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.asusd;

  tomlFormat = pkgs.formats.toml {};

  restartSettings =
    if cfg.alwaysKeepRunning
    then "always"
    else "on-failure";
in {
  # options = {
  #   services.asusd = {
  #     enable = mkEnableOption ''
  #       an interface for rootless control of system functions for Asus ROG-like laptops.
  #       This will allow usage of <code>asusctl</code> to control hardware such as fan speeds, keyboard LEDs and graphics modes
  #     '';

  #     ledmodes = mkOption {
  #       type = tomlFormat.type;
  #       description = ''
  #         <filename>asusd-user-ledmodes.toml</filename> as a Nix attribute set.
  #         See <link xlink:href="https://gitlab.com/asus-linux/asusctl/-/blob/main/data/asusd-ledmodes.toml">asusd-ledmodes.toml</link> for examples.
  #         This is loaded alongside with asusd-ledmodes.toml.
  #       '';
  #       default = {};
  #     };

  #     power-profiles = mkOption {
  #       type = types.bool;
  #       default = false;
  #       description = ''
  #         Enable asusd integration with power-profiles-daemon, which is necessary
  #         for <code>asusctl profile -n</code> subcommand.
  #       '';
  #     };

  #     alwaysKeepRunning = mkOption {
  #       type = types.bool;
  #       default = false;
  #       description = ''
  #         If enabled, systemd will always respawn asusd even if shut down manually. The default, disabled, will only restart it on error.
  #       '';
  #     };
  #   };
  # };

  # config = mkIf cfg.enable (mkMerge [
  #   {
  #     environment.systemPackages = [pkgs.asusctl];
  #     services.dbus.packages = [pkgs.asusctl];

  #     # Avoiding adding udev rules file of asusctl as-is due to the reference to systemd.
  #     # Set the udev rules manually, see ${pkgs.asusctl}/lib/udev/rules.d/99-asusd.rules
  #     services.udev.extraRules = ''
  #       ACTION=="add|change", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", ENV{ID_TYPE}=="hid", TAG+="systemd", ENV{SYSTEMD_WANTS}="asusd.service"
  #       ACTION=="add|remove", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", RUN+="${pkgs.systemd}/bin/systemctl restart asusd.service"
  #     '';

  #     # Set the ledmodes to the packaged ledmodes by default.
  #     environment.etc."asusd/asusd-ledmodes.toml".source = "${pkgs.asusctl}/etc/asusd/asusd-ledmodes.toml";

  #     # Convert Nix attribute-set to TOML.
  #     environment.etc."asusd/asusd-user-ledmodes.toml".source = tomlFormat.generate "asusd-user-ledmodes.toml" cfg.ledmodes;

  #     services.supergfxd.enable = mkDefault true;

  #     systemd.services.asusd = {
  #       description = "Asus Control Daemon";
  #       wantedBy = ["multi-user.target"];
  #       wants = ["dbus.socket"];
  #       environment.IS_SERVICE = "1";
  #       unitConfig = {
  #         StartLimitInterval = 0; #200;
  #         StartLimitBurst = 2;
  #       };
  #       serviceConfig = {
  #         ExecStart = "${pkgs.asusctl}/bin/asusd";
  #         Restart = restartSettings;
  #         RestartSec = 4; #1;
  #         Type = "dbus";
  #         BusName = "org.asuslinux.Daemon";
  #         SELinuxContext = "system_u:system_r:unconfined_t:s0";
  #         # ConfigurationDirectory = "asusd";
  #       };
  #     };

  #     systemd.user.services.asus-notify = {
  #       description = "ASUS Notifications";
  #       wantedBy = ["default.target"];
  #       unitConfig = {
  #         StartLimitInterval = 200;
  #         StartLimitBurst = 2;
  #       };
  #       serviceConfig = {
  #         ExecStart = "${pkgs.asusctl}/bin/asus-notify";
  #         Restart = restartSettings;
  #         RestartSec = 1;
  #         Type = "simple";
  #       };
  #     };

  #     services.actkbd = {
  #       enable = mkDefault true;
  #       bindings = [
  #         {
  #           keys = [229]; # fn + f2
  #           events = ["key" "rep"];
  #           command = "${pkgs.asusctl}/bin/asusctl --prev-kbd-bright";
  #         }
  #         {
  #           keys = [230]; # fn + f3
  #           events = ["key" "rep"];
  #           command = "${pkgs.asusctl}/bin/asusctl --next-kbd-bright";
  #         }
  #         {
  #           keys = [202]; # fn + f4
  #           events = ["key" "rep"];
  #           command = "${pkgs.asusctl}/bin/asusctl led-mode --next-mode";
  #         }
  #         {
  #           keys = [203]; # fn + f5
  #           events = ["key" "rep"];
  #           command = "${pkgs.asusctl}/bin/asusctl profile --next";
  #         }
  #         # {
  #         #   keys = [224];
  #         #   events = ["key" "rep"];
  #         #   command = "";
  #         # }
  #       ];
  #     };
  #   }

  #   (mkIf cfg.power-profiles {
  #     services.power-profiles-daemon.enable = mkDefault true;

  #     systemd.services.power-profiles-daemon = {
  #       wantedBy = ["multi-user.target"];
  #     };
  #   })
  # ]);
}
