{
  writeShellScriptBin,
  socat,
}:
writeShellScriptBin "hyprland-window-name-listener" ''
  set -o pipefail

  function handle {
    case "$1" in
      'activewindow>>'*)
        TEXT="''${1:14}"
        TEXT="''${TEXT/,/: }"
        ;;
      'fullscreen>>'*)
        (( "''${1:12}" )) && CLASS="fullscreen" || CLASS=""
        ;;
    esac

  cat << EOF
  { "text": "''${TEXT}", "class": "''${CLASS}" }
  EOF

  }

  ${socat}/bin/socat -U - UNIX-CONNECT:/tmp/hypr/''${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock | while read line; do handle $line; done
''
