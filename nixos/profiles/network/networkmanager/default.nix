{ ... }: {
  networking.networkmanager = {
    enable = true;
    ethernet.macAddress = "stable";
  };
}
