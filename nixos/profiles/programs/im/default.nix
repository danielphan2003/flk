{pkgs, ...}: let
  inherit (builtins) attrValues;
in {
  environment.systemPackages = attrValues ({
      inherit
        (pkgs)
        element-desktop
        # lightcord
        
        tdesktop
        ;

      cinny-desktop = pkgs.cinny-desktop.override {
        conf = {
          defaultHomeserver = 0;
          homeserverList = ["c-137.me" "matrix.org"];
        };
      };
    }
    // (
      if pkgs.system == "x86_64-linux"
      then {
        inherit (pkgs) discord-canary signal-desktop;
      }
      else {
        inherit (pkgs) cordless signal-cli;
      }
    ));
}
