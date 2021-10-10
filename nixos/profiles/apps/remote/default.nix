{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      anydesk
      freerdp
      scrcpy
      tigervnc
      ;
  };
}
