{ writeShellScript, ripgrep, playerctl }:
writeShellScript "play-pause" ''

  PLAYER="$1"

  [ "$PLAYER" -eq "other" ] && PLAYER="$(${playerctl}/bin/playerctl -l | ${ripgrep}/bin/rg --pcre2 '^(?!firefox|spotify|vlc)([a-z0-9]+)')"

  PLAYERCTL="${playerctl}/bin/playerctl -p $PLAYER"

  $PLAYERCTL play-pause
''
