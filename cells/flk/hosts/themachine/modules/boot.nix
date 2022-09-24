{pkgs, ...}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  boot.kernelModules = [
    # external usb closures
    "uas"
    "usb_storage"

    # AMD hardware virtualisation
    "kvm-amd"
  ];
}
