{ pkgs, ... }: {
  services.kanshi = {
    enable = true;
    package = pkgs.waylandPkgs.kanshi;
    profiles.default.outputs = [
      {
        criteria = "HDMI-A-1";
        mode = "1920x1080";
        position = "0,0";
      }
    ];
  };
}
