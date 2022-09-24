{config, ...}: {
  services.greetd.settings.initial_session = {
    user = config.users.users.danie.name;
    # command = "/run/current-system/sw/bin/sway --config ${config.users.users.danie.home}/.config/sway/config";
    command = "/etc/profiles/per-user/danie/bin/Hyprland --config ${config.users.users.danie.home}/.config/hypr/hyprland.conf";
  };
}
