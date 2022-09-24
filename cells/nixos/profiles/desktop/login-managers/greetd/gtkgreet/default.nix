{pkgs, ...}: {
  programs.sway.enable = true;

  services.greetd.settings.default_session.command = let
    default_cmd = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";

    backgroundDir = "/mnt/danie/Slideshows/Home";

    generateCss = let
      opaque = "80";
    in
      pkgs.writeShellScript "generate-gtkgreet-css.sh" ''
        export HOME=$(${pkgs.coreutils}/bin/mktemp -d -t greetd-XXXXXXXXXX)

        ${pkgs.pywal}/bin/wal -i "${backgroundDir}" -stneq

        . $HOME/.cache/wal/colors.sh

        sed \
          -e "s#@bg_img@#$wallpaper#g" \
          -e "s/@bg@/$bg$opaque/g" \
          ${./style.css} > "$HOME/style.css"

        echo "$HOME/style.css"
      '';

    swayConfig = pkgs.writeText "sway-greetd.conf" ''
      xwayland false

      exec dbus-update-activation-environment --systemd \
        DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP \
        GTK_IM_MODULE QT_IM_MODULE XMODIFIERS DBUS_SESSION_BUS_ADDRESS

      # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
      exec "${default_cmd} -l -s $(${generateCss}); swaymsg exit"

      bindsym Mod4+shift+e exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'

      include /etc/sway/config.d/*
    '';
  in "/run/current-system/sw/bin/sway --config ${swayConfig}";
}
