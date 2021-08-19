{ writeScriptBin
, eww
, substituteAll
}:
let
  button = builtins.readFile ../../../../home/profiles/eww/config/templates/mpris/button.yuck;
  box = builtins.readFile ../../../../home/profiles/eww/config/templates/mpris/box.yuck;
in
writeScriptBin "eww-mpris"
  (builtins.readFile
    (substituteAll {
      src = ./mpris.py;
      inherit button box eww;
    }))
