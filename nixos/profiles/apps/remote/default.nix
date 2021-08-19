{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      freerdp
      tigervnc
      ;
  };
}
