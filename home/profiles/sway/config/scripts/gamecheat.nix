{ lib, writeShellScript, rofi, ydotool }:
let
  cheats = [
    "1. Vũ khí hạng nặng"
    "2. Đầy đủ sức khỏe"
    "3. Đuổi cảnh sát"
    "4. Đầy đủ áo giáp"
  ];
  binPath = lib.makeBinPath [ rofi ydotool ];
in
writeShellScript "gamecheat.sh" ''
  PATH=$PATH:${binPath}

  case "$(printf "${lib.concatStringsSep ''\n'' cheats}" | rofi -dmenu)" in
    "1*") ydotool type "NUTTERTOOLS" ;;
    "2*") ydotool type "ASPIRINE" ;;
    "3*") ydotool type "LEAVEMEALONE" ;;
    "4*") ydotool type "PRECIOUSPROTECTION" ;;
  esac
''
