{ ... }: {
  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };
  };
}
