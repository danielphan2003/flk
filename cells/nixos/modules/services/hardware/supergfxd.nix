{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.supergfxd;

  singleUpper = s:
    concatStrings (imap0 (i: v:
      if i == 0
      then toUpper v
      else v) (stringToCharacters s));

  restartSettings =
    if cfg.alwaysKeepRunning
    then "always"
    else "on-failure";

  configFile = let
    configJson = builtins.toJSON {
      mode = singleUpper cfg.mode;
      vfio_enable = cfg.vfio.enable;
      vfio_save = cfg.vfio.save;
      compute_save = cfg.compute.save;
      always_reboot = cfg.alwaysReboot;
      no_logind = !cfg.logind;
      logout_timeout_s = cfg.logoutTimeout;
    };
  in
    pkgs.writeText "supergfxd.conf" configJson;
in {
  options = {
    services.supergfxd = {
      enable = mkEnableOption ''
        an interface for rootless control of system functions for Asus ROG-like laptops.
        This will allow usage of <code>supergfxctl</code> to control hardware such as graphics modes
      '';

      mode = mkOption {
        description = "Sets the default GPU mode that is applied on boot.";
        type = types.enum ["hybrid" "integrated" "vfio" "dedicated" "compute" "egpu"];
        default = "hybrid";
      };

      vfio = {
        enable = mkEnableOption "VFIO switching for dGPU passthrough";
        save = mkOption {
          type = types.bool;
          default = false;
          description = "Save vfio state in mode (so it sticks between boots)";
        };
      };

      compute.save = mkOption {
        type = types.bool;
        default = false;
        description = "Save compute state in mode (so it sticks between boots)";
      };

      alwaysReboot = mkOption {
        type = types.bool;
        default = false;
        description = "Whether supergfxd should always require a reboot to change modes (helps some laptops)";
      };

      logind = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Disable logind to see if all sessions are logged out and therefore safe to change mode.
          This will be useful for people not using a login manager. Ignored if <code>alwaysReboot</code> is set.
        '';
      };

      logoutTimeout = mkOption {
        type = types.int;
        default = 180;
        description = ''
          The timeout in seconds to wait for all user graphical sessions to end. Default is 3 minutes, 0 = infinite.
          Ignored if <code>logind</code> is disabled or <code>alwaysReboot</code> is enabled.
        '';
      };

      alwaysKeepRunning = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, systemd will always respawn supergfxd even if shut down manually. The default, disabled, will only restart it on error.
        '';
      };

      modesetting.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable kernel modesetting when using the NVIDIA proprietary driver.

          Enabling this fixes screen tearing when using Optimus via PRIME (see
          <option>hardware.nvidia.prime.sync.enable</option>). This is not enabled
          by default because it is not officially supported by NVIDIA and would not
          work with SLI.

          If enabled, supergfxd requires a reboot to change between graphic modes.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [pkgs.supergfxctl];
      services.dbus.packages = [pkgs.supergfxctl];
      services.udev.packages = [pkgs.supergfxctl];

      # Copy configFile to /etc so supergfxctl can change graphic mode.
      # Note that this would discard any changes supergfx made in the previous boot.
      # To keep your settings, choose graphic mode in NixOS config instead.
      systemd.tmpfiles.rules = ["C /etc/supergfxd.conf - - - - ${configFile}"];

      boot.kernelParams = optional cfg.modesetting.enable "nvidia-drm.modeset=1";

      systemd.services.supergfxd = {
        description = "SUPERGFX";
        wantedBy = ["multi-user.target"];
        wants = ["dbus.socket"];
        unitConfig = {
          StartLimitInterval = 200;
          StartLimitBurst = 2;
        };
        environment.IS_SUPERGFX_SERVICE = "1";
        serviceConfig = {
          ExecStart = "${pkgs.supergfxctl}/bin/supergfxd";
          Restart = restartSettings;
          RestartSec = 1;
          Type = "dbus";
          BusName = "org.supergfxctl.Daemon";
          SELinuxContext = "system_u:system_r:unconfined_t:s0";
        };
      };
    }

    (mkIf (cfg.mode == "dedicated") {
      services.xserver.videoDrivers = mkDefault ["nvidia" "nvidia-drm" "nvidia-modeset" "nvidia-uvm"];
    })
  ]);
}
