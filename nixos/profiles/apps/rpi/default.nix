{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      raspberrypifw
      raspberrypi-eeprom
      libraspberrypi
      ;
  };
}
