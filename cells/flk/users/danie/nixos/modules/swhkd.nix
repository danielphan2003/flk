{config, ...}: {
  services.swhkd.extraConfig = ''
    include ${config.users.users.danie.home}/.config/swhkd/swhkdrc
  '';

  systemd.user.services.swhks.enable = false; # !config.home-manager.users.danie.services.swhks.enable;
}
