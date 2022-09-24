{...}: {
  boot.initrd.availableKernelModules = ["nvme"];

  boot.initrd.luks.devices = {
    system = {
      device = "/dev/disk/by-partlabel/cryptsystem";
      allowDiscards = true;
    };
  };
}
