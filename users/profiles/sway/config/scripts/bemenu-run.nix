{ writeShellScript, bemenu, sway, jq }:
writeShellScript "bemenu-run.sh" ''

  if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    source $HOME/.cache/wal/colors.sh
  else
    background='#1a1a1a'
    color5='#268bd2'
    #color6='#2E3440'
  fi

  BEMENU_ARGS=(-n -i -p "" --tb "$background" --tf "$color5" --fb "$background" --nb "$background" --hb "$background" --hf "$color5" -m $(${sway}/bin/swaymsg -r -t get_outputs | ${jq}/bin/jq '. | reverse | to_entries | .[] | select(.value.focused == true) | .key') "$@")

  if [ "$1" = 'bemenu' ]; then
    ${bemenu}/bin/bemenu-run ''${BEMENU_ARGS[@]}
  else
    ${bemenu}/bin/bemenu ''${BEMENU_ARGS[@]}
  fi
''
