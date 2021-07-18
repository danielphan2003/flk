{ writeShellScript, bemenu-run, screenshare }:
writeShellScript "bemenu-screenshare.sh" ''

  ## Shows a dropdown menu to start, stop or view the status of screensharing

  case "$(echo -e " Start\n Stop\n Status" | ${bemenu-run} -l 4 -p "Screensharing:")" in
    " Start") ${screenshare} ;;
    " Stop") ${screenshare} stop ;;
    " Status") ${screenshare} is-recording ;;
  esac
''
