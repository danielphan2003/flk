{inputs, ...}: {
  imports = builtins.attrValues {
    inherit
      (inputs.nixos-hardware.nixosModules)
      common-cpu-amd
      common-gpu-amd
      common-pc-ssd
      ;
  };
}
