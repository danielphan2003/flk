{ writeShellScriptBin, lib, sway, jq }:
writeShellScriptBin "swayprop" ''
  PATH="$PATH:${lib.makeBinPath [ sway jq ]}"

  ALL_NODES='recurse(.nodes[]?, .floating_nodes[]?) | select(.pid and .visible)'
  WINDOW_NAME='(.app_id // .window_properties.class)'
  ID_PREFIX='"\(.id):"'
  WINDOW_PROTOCOL='(if .shell == "xwayland" then "X11" else "wayland" end)'
  WINDOW_GEOMETRY='(.rect | "\(.x),\(.y) \(.width)x\(.height) ")'
  WINDOW_PID='(.pid | tostring)'

  # Output format, e.g. "1234 - 12:firefox (wayland)" or "5678 - 17:discord (X11)"
  FORMAT="$WINDOW_PID + \" - \" + $ID_PREFIX + $WINDOW_NAME + \" (\" + $WINDOW_PROTOCOL + \")\""
  FILT="$ALL_NODES | $WINDOW_GEOMETRY + $FORMAT"

  function getprop() {
    typeset -A views
    local selected

    while read POS GEOM INFO; do
      views["$POS $GEOM"]="$INFO"
    done

    selected="$(printf "%s\n" "''${!views[@]}" | slurp)"
    if [[ -n "$selected" ]]; then
      printf '%s\n' "''${views[''${selected}]}"
    fi
  }

  if [[ "$1" == "wait" ]]; then
    swaymsg -t subscribe '["workspace"]' | jq -r ".current | $FILT" | getprop
  else
    swaymsg -t get_tree | jq -r "$FILT" | getprop
  fi
''
