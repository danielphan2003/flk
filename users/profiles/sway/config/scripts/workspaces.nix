{ pkgs, ... }:
let inherit (pkgs) sway;
in pkgs.writers.writeBash "workspaces.sh" ''
  if ! ${sway}/bin/swaymsg workspace $@; then
    if [ $@ -eq 1 ]; then
      riverctl set-focused-tags $((1 << ($@ - 1)))
    else
      riverctl set-focused-tags $((1 << ($@ - 5)))
    fi
  fi
''
