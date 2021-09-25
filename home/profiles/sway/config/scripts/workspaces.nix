{ writeShellScript, sway-unwrapped, ... }:
writeShellScript "workspaces.sh" ''
  if ! ${sway-unwrapped}/bin/swaymsg workspace $@; then
    if [ $@ -eq 1 ]; then
      riverctl set-focused-tags $((1 << ($@ - 1)))
    else
      riverctl set-focused-tags $((1 << ($@ - 5)))
    fi
  fi
''
