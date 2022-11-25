let
  inherit (inputs.cells) nixos;
in {
  rog-bootstrap = {pkgs, ...}: {
    imports =
      [
        inputs.hive.x86_64-linux._QUEEN.nixosSuites.larva
      ]
      ++ nixos.nixosSuites.limitless
      ++ nixos.nixosSuites.mobile;

    boot.kernelPackages = pkgs.linuxPackages_5_18;

    services.asusd = {
      enable = true;
      power-profiles = true;
    };

    systemd.services.battery-charge-threshold.enable = false;

    services.xserver.videoDrivers = [];

    hardware.nvidia.prime.offload.enable = false;

    programs.sway.enable = true;

    environment.etc."sway/config".text = ''
      include ${pkgs.sway}/etc/sway/config
      bindsym Mod1+Return ${pkgs.wezterm}/bin/wezterm
      exec systemctl --user import-environment
    '';
  };
}
