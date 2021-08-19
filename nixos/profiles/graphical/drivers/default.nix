{ pkgs, ... }: {
  hardware.opengl = {
    setLdLibraryPath = true;
    enable = true;
    extraPackages = [ pkgs.libGL_driver ];
  };
}
