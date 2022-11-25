let
  inherit (inputs.cells) nixos;
in {
  rog-bootstrap = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixos-hardware.nixosModules.asus-rog-strix-g733qs
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia #-disable
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ];
  };
}
