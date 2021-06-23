{ pamixer, gnugrep, volnoti, writers }:
let inherit (writers) writeBash;
in writeBash "volnoti.sh" ''
  declare -i current=$(${pamixer}/bin/pamixer --get-volume)
  [ $current -gt 100 ] && current=100

  if [ "$(${pamixer}/bin/pamixer --get-volume-human)" = "muted" ]; then
    ${volnoti}/bin/volnoti-show -m $current
  else
    ${volnoti}/bin/volnoti-show $current
  fi
''
