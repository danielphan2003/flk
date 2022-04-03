{
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
in {
  hardware.video.hidpi.enable = true;

  hardware.opengl = {
    setLdLibraryPath = true;
    enable = true;
    extraPackages = attrValues {
      inherit
        (pkgs)
        libglvnd
        libGL_driver
        mesa
        ;
    };
  };
}
