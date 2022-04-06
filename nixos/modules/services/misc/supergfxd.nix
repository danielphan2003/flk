{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.supergfxd;
in {
  options = {
    services.supergfxd = {
      enable = mkEnableOption ''
        an interface for rootless control of system functions for Asus ROG-like laptops.
        This will allow usage of <code>supergfxctl</code> to control hardware such as graphics modes
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [supergfxctl];
    services.dbus.packages = with pkgs; [supergfxctl];
    services.udev.packages = with pkgs; [supergfxctl];

    boot.kernelParams = ["nvidia-drm.modeset=0"];

    systemd.services.supergfxd = {
      description = "SUPERGFX";
      wantedBy = ["multi-user.target"];
      wants = ["dbus.socket"];
      environment.IS_SUPERGFX_SERVICE = "1";
      unitConfig = {
        StartLimitInterval = 200;
        StartLimitBurst = 2;
      };
      serviceConfig = {
        Type = "dbus";
        BusName = "org.supergfxctl.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
        ExecStart = "${pkgs.supergfxctl}/bin/supergfxd";
        Restart = "always";
        RestartSec = "1s";
      };
    };
  };
}
