{ pkgs, ... }: {
  programs.adb.enable = true;

  services.teamviewer.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      anydesk
      freerdp
      # realvnc-vnc-viewer
      scrcpy
      tigervnc
      ;
  };
}
