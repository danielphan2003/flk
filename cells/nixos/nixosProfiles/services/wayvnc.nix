{config, ...}: {
  home-manager.sharedModules = [
    {services.wayvnc.addr = config.flk.currentHost.tailscale.ip;}
  ];
}
