{ coreutils
, writeShellScript
, sway
, waylandPkgs
, jq
, ffmpeg
, libnotify
, procps
}:
let inherit (waylandPkgs) wf-recorder slurp; in
writeShellScript "screenshare.sh" ''

  ## Starts, stops and shows status for screensharing

  geometry() {
    windowGeometries=$(
      # `height - 1` is there because of: https://github.com/ammen99/pull/56 (I could remove it if it's merged, maybe)
      ${sway}/bin/swaymsg -t get_workspaces -r | ${jq}/bin/jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height - 1)"'
      ${sway}/bin/swaymsg -t get_outputs -r | ${jq}/bin/jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
    )
    geometry=$(${slurp}/bin/slurp -b "#45858820" -c "#45858880" -w 3 -d <<<"$windowGeometries") || exit $?
    echo "$geometry"
  }

  {
    if [ "$1" == "stop" ]; then
      if ${procps}/bin/pgrep ${ffmpeg}/bin/ffplay >/dev/null; then
        pkill ${ffmpeg}/bin/ffplay >/dev/null
      fi
      if ${procps}/bin/pgrep ${wf-recorder}/bin/wf-recorder >/dev/null; then
        pkill ${wf-recorder}/bin/wf-recorder >/dev/null
      fi
      ${libnotify}/bin/notify-send -t 2000 "Wayland recording has been stopped"
    elif [ "$1" == "is-recording" ]; then
      if ${procps}/bin/pgrep ${wf-recorder}/bin/wf-recorder >/dev/null; then
        ${libnotify}/bin/notify-send -t 2000 "Wayland recording is up"
      else
        ${libnotify}/bin/notify-send -t 2000 "No Wayland recording"
      fi
    else
      if ! ${procps}/bin/pgrep ${wf-recorder}/bin/wf-recorder >/dev/null; then
        geometry=$(geometry) || exit $?
        unset SDL_VIDEODRIVER
        ${wf-recorder}/bin/wf-recorder -c rawvideo -x yuv420p -m avi -f >(${ffmpeg}/bin/ffplay -window_title Screenshare -f avi -) --geometry="$geometry" &
        ${coreutils}/bin/sleep 0.5
        # a hack so FPS is not dropping
        ${sway}/bin/swaymsg [title=Screenshare] floating enable, move position 1800 900
      fi
      ${libnotify}/bin/notify-send -t 2000 "Wayland recording has been started"
    fi
  }
  # > ~/.wayland-share-screen.log 2>&1
''
