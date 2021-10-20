{ writeShellScript, ripgrep, playerctl, pango-escape-text }:
writeShellScript "mediaplayer" ''

  PLAYERCTL="${playerctl}/bin/playerctl"

  PLAYER="$1"

  ICON="$2"

  PLAYERCTL_WRAPPED="$PLAYERCTL -p $PLAYER"

  case "$PLAYER" in
    firefox)
      TOOLTIP="Firefox"
      TEXT="$ICON $($PLAYERCTL_WRAPPED metadata title)"
      ;;
    spotify)
      TOOLTIP="Spotify"
      TEXT="$ICON $($PLAYERCTL_WRAPPED metadata artist) - $($PLAYERCTL_WRAPPED metadata title)"
      ;;
    vlc)
      TOOLTIP="VLC"
      TEXT="$ICON $($PLAYERCTL_WRAPPED -p vlc metadata title)"
      ;;
    *)
      PLAYER="$(${playerctl}/bin/playerctl -l | ${ripgrep}/bin/rg --pcre2 '^(?!firefox|spotify|vlc)([a-z0-9]+)')"
      PLAYERCTL="$PLAYERCTL -p $PLAYER"
      TOOLTIP="$(${pango-escape-text} `$PLAYERCTL metadata title`)"
      TEXT="$ICON $($PLAYERCTL metadata artist) - $($PLAYERCTL metadata title)"
      ;;
  esac

  TEXT=$(${pango-escape-text} "$TEXT")

  CLASS=$($PLAYERCTL status)
''
