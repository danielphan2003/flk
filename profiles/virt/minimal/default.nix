{ pkgs, ... }: {
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
      qemuRunAsRoot = false;
      onBoot = "ignore";
      allowedBridges = [
        "virbr0"
        "virbr1"
        "virbr0-nic"
        "docker0"
      ];
    };

    spiceUSBRedirection.enable = true;
  };

  environment.sessionVariables = {
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };

  security.wrappers.spice-client-glib-usb-acl-helper = {
    source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
    capabilities = "cap_fowner+ep";
  };
}
