{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  initrd.availableKernelModules = ["ashmem_linux" "binder_linux"];
  extraModprobeConfig = ''
    options binder_linux devices=binder,hwbinder,vndbinder
  '';

  virtualisation.waydroid.enable = true;

  systemd.network.netdevs.waydroid-bridge = {
    netdevConfig = {
      Name = "waydroid0";
      Kind = "bridge";
    };
  };

  systemd.network.networks.waydroid-bridge = {
    matchConfig.Name = "waydroid0";

    networkConfig = {
      Address = "192.168.250.1/24";
      DHCPServer = "yes";
      IPForward = "yes";
      ConfigureWithoutCarrier = "yes";
    };

    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 20;
      EmitDNS = "yes";
      DNS = "9.9.9.9";
    };
  };
}
