{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      anydesk
      freerdp
      tigervnc
      ;
  };
}
