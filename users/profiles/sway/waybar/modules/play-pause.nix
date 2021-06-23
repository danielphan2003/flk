{ bash, writeScript, gnused, playerctl }:
writeScript "play-pause" ''
  #!/usr/bin/env ${bash}/bin/bash

  PLAYER="$1"
  
  [ -n "$PLAYER" ] && PLAYER="$(${playerctl}/bin/playerctl -l | ${gnused}/bin/sed -n "$PLAYER"p)"

  PLAYERCTL="${playerctl}/bin/playerctl -p $PLAYER"

  $PLAYERCTL play-pause
''