{pkgs, ...}: {
  services.avizo.enable = true;

  home.packages = [pkgs.avizo];
}
