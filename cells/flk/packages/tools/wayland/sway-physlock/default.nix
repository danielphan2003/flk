{
  writeShellScriptBin,
  swaylock,
  physlock,
  sudo,
}:
writeShellScriptBin "sway-physlock" ''
  # Also lock tty
  /run/wrappers/bin/${sudo.pname} ${physlock}/bin/physlock -l && (${swaylock}/bin/swaylock && /run/wrappers/bin/${sudo.pname} ${physlock}/bin/physlock -L)&
''
