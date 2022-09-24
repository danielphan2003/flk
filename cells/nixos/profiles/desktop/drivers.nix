{pkgs, ...}: {
  hardware.video.hidpi.enable = true;

  hardware.opengl = {
    setLdLibraryPath = true;
    enable = true;
    extraPackages = builtins.attrValues {
      inherit
        (pkgs)
        libglvnd
        mesa
        ;
      inherit (pkgs.mesa) drivers;
    };
  };
}
