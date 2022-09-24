{inputs, ...}: {
  imports = builtins.attrValues {
    inherit
      (inputs.nixos-hardware.nixosModules)
      asus-rog-strix-g733qs
      common-gpu-nvidia #-disable
      common-pc-laptop
      common-pc-laptop-acpi_call
      common-pc-laptop-ssd
      ;
  };

  services.asusd = {
    enable = true;
    power-profiles = true;
  };

  systemd.services.battery-charge-threshold.enable = false;

  services.xserver.videoDrivers = [];

  hardware.nvidia.prime.offload.enable = false;
}