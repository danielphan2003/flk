{ lib, writeShellScript, rofi, wlrctl }:
let
  cheats = {
    "1. Vũ khí hạng nặng" = "NUTTERTOOLS";
    "2. Đầy đủ sức khỏe" = "ASPIRINE";
    "3. Đuổi cảnh sát" = "LEAVEMEALONE";
    "4. Đầy đủ áo giáp" = "PRECIOUSPROTECTION";
  };
  mapCheatSelection = selection: cheat:
    ''"${selection}") sleep 1 && wlrctl keyboard type "${cheat}" ;;'';
  selections = lib.mapAttrsToList mapCheatSelection cheats;
  binPath = lib.makeBinPath [ rofi wlrctl ];
in
writeShellScript "gamecheat.sh" ''
  PATH=$PATH:${binPath}

  case "$(printf "${lib.concatStringsSep ''\n'' (builtins.attrNames cheats)}" | rofi -dmenu)" in
    ${lib.concatStringsSep "\n" selections}
  esac
''
