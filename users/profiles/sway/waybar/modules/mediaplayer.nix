{ bash, writeScript, gnused, playerctl, pango-escape-text }:
writeScript "mediaplayer" ''
  #!/usr/bin/env ${bash}/bin/bash

  PLAYERCTL="${playerctl}/bin/playerctl"

  PLAYER="$1"
  
  case "$PLAYER" in
    *firefox*)
      TOOLTIP="Firefox"
      TEXT="$($PLAYERCTL -p firefox metadata title)"
      ;;
    *potify*)
      TOOLTIP="Spotify"
      TEXT="  $($PLAYERCTL -p firefox metadata title)"
      ;;
    *)
      PLAYER="$(${playerctl}/bin/playerctl -l | ${gnused}/bin/sed -n "$PLAYER"p)"
      TOOLTIP="$(${pango-escape-text} "$(${playerctl}/bin/playerctl -p $PLAYER metadata title)")"
      ;;
  esac

  PLAYERCTL="${playerctl}/bin/playerctl -p $PLAYER"

  TEXT="$($PLAYERCTL metadata artist) - $($PLAYERCTL metadata title)"

  TEXT=$(${pango-escape-text} "$TEXT")

  CLASS=$($PLAYERCTL status)
''