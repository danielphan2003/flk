{
  pkgs,
  profiles,
  ...
}: {
  imports = [
    profiles.programs.gamemode
    profiles.services.udev.game-controller
  ];

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      # pcsx2
      
      polymc
      qjoypad
      retroarchBare
      ;
  };

  services.wii-u-gc-adapter.enable = true;

  # fps games on laptop need this
  services.xserver.libinput.touchpad.disableWhileTyping = false;

  # Launch steam from display managers
  # services.xserver.windowManager.steam = { enable = true; };
  programs.steam.enable = true;

  # 32-bit support needed for steam
  hardware.opengl.driSupport32Bit = true;
  services.pipewire.alsa.support32Bit = true;

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  environment.sessionVariables = {WINEDEBUG = "-all";};
}
