{pkgs, ...}: {
  boot.loader.systemd-boot.enable = false;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  boot.initrd.availableKernelModules = [
    # crypto related
    "adiantum"
    "xchacha20"
    "nhpoly1305"

    # external nvme usb closures
    "nvme"
    "uas"
  ];
}
