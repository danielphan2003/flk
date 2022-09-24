{pkgs, ...}: {
  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = with pkgs; [
    virt-manager
    vagrant
    docker-compose
    spice-gtk
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
        swtpm.enable = true;
      };
      onBoot = "ignore";
      allowedBridges = [
        "virbr0"
        "virbr1"
        "virbr0-nic"
        "docker0"
      ];
    };

    # spiceUSBRedirection.enable = true;
  };

  environment.sessionVariables = {
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };
}
