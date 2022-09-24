{pkgs, ...}: {
  services.udev.packages = [pkgs.android-udev-rules];
}
