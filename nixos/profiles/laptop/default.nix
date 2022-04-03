{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit
      (pkgs)
      acpi
      lm_sensors
      wirelesstools
      pciutils
      usbutils
      ;
  };

  hardware.bluetooth.enable = true;

  networking.networkmanager.wifi = {
    backend = "iwd";
    macAddress = "stable";
  };

  networking.wireless.enable = true;

  # to enable brightness keys 'keys' value may need updating per device
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [225];
        events = ["key"];
        command = "${pkgs.light}/bin/light -A 5";
      }
      {
        keys = [224];
        events = ["key"];
        command = "${pkgs.light}/bin/light -U 5";
      }
    ];
  };

  sound.mediaKeys = lib.mkIf (!config.services.pipewire.pulse.enable) {
    enable = true;
    volumeStep = "1dB";
  };

  # power management features
  services.tlp = {
    enable = !config.services.power-profiles-daemon.enable;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_HWP_ON_AC = "performance";
    };
  };

  services.logind.lidSwitch = "suspend";
}
