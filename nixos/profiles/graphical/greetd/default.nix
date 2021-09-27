{ pkgs, config, ... }:
let
  default_cmd = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";

  backgroundDir = "/mnt/danie/Slideshows/Home";

  generateCss = let opaque = "80"; in
    pkgs.writeShellScript "generate-gtkgreet-css.sh" ''
      export HOME=$(${pkgs.coreutils}/bin/mktemp -d -t greetd-XXXXXXXXXX)
      ${pkgs.pywal}/bin/wal -i "${backgroundDir}" -stneq
      . $HOME/.cache/wal/colors.sh
      mkdir -p /etc/greetd
      sed \
        -e "s#@bg_img@#$wallpaper#g" \
        -e "s/@bg@/$bg$opaque/g" \
        ${./gtkgreet.css} > "/etc/greetd/gtkgreet.css"
    '';

  swayConfig = pkgs.writeText "sway-greetd.conf" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${generateCss}; ${default_cmd} -l -s /etc/greetd/gtkgreet.css; swaymsg exit"

    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    include /etc/sway/config.d/*
  '';
in
{
  programs.sway.enable = true;

  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
        user = config.users.users.greeter.name;
      };
    };
  };
}
