{
  config,
  lib,
  pkgs,
  ...
}: {
  assertions = [
    {
      assertion = with config.hardware.raspberry-pi."4"; !(i2c-bcm2708.enable) && i2c1.enable;
      message = ''
        [hardware.raspberry-pi."4"] Do not enable both `i2c-bcm2708` and `i2c1` at the same time!
      '';
    }
  ];

  hardware.argon-one.power-button.enable = true;

  hardware.raspberry-pi."4".i2c1.enable = lib.mkDefault true;
  hardware.raspberry-pi."4".i2c-bcm2708.enable = lib.mkDefault (!config.hardware.raspberry-pi."4".i2c1.enable);

  boot.initrd.kernelModules = ["i2c-dev" "i2c-bcm2835" "gpio-keys"];
  boot.kernelModules = ["i2c-dev" "i2c-bcm2835" "gpio-keys"];

  systemd.services.argonone-fancontrold = {
    enable = true;
    wantedBy = ["default.target"];

    serviceConfig = {
      DynamicUser = true;
      Group = "i2c";

      ExecStart = "${pkgs.argonone-fancontrold}/bin/argonone-fancontrold";
    };
  };
}
