{ pkgs, lib, ... }:
let inherit (builtins) attrValues; in
{
  hardware.video.hidpi.enable = true;

  hardware.opengl = {
    setLdLibraryPath = true;
    enable = true;
    driSupport = true;
    driSupport32Bit = lib.mkDefault true;
    extraPackages = attrValues {
      inherit (pkgs)
        libGL_driver
        rocm-opencl-icd
        rocm-opencl-runtime
        ;
    };
  };
}
