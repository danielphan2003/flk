{ bash, coreutils, writeScript, gnused, playerctl }:
writeScript "spotify" ''

  TEXT="Unknown"
  ICON=""
  CLASS=$(${playerctl}/bin/playerctl metadata --player=spotify --format '{{lc(status)}}')

  case "$CLASS" in
    "playing")
      INFO=$(${playerctl}/bin/playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
      [ ''${#INFO} > 35 ] && INFO=$(echo $INFO | ${coreutils}/bin/cut -c1-35)"..."
      TEXT=$INFO" "$ICON
      ;;
    "paused")
      TEXT=$ICON
      ;;
    "stopped")
      TEXT=""
      ;;
  esac
''
