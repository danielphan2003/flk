{writeShellScriptBin}:
writeShellScriptBin "flkup" ''
  if [[ -n "$1" ]]; then
    nix flake lock --update-input "$1" "$PRJ_ROOT"
  else
    nix flake update "$PRJ_ROOT"
  fi
''