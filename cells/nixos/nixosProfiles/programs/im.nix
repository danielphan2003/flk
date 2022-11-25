{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = let
    imCompat =
      if pkgs.system == "x86_64-linux"
      then {inherit (pkgs) discord-canary signal-desktop;}
      else {inherit (pkgs) cordless signal-cli;};

    imPkgs = {
      inherit
        (pkgs)
        element-desktop
        tdesktop
        ;

      cinny-desktop = pkgs.cinny-desktop.override {
        conf = {
          defaultHomeserver = 0;
          homeserverList = [config.networking.domain "matrix.org"];
        };
      };
    };
  in
    builtins.attrValues (imCompat // imPkgs);
}
