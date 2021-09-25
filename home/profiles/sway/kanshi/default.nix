{ pkgs, ... }: {
  services.kanshi = {
    enable = true;
    profiles.default.outputs = [
      {
        criteria = "HDMI-A-1";
        mode = "1920x1080";
        position = "0,0";
      }
    ];
  };
}
