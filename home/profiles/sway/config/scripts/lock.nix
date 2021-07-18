{ bash, swaylock-effects, writeShellScript }:
writeShellScript "lock.sh" ''

  . ~/.cache/wal/colors-oomox

  ${swaylock-effects}/bin/swaylock --screenshots --clock --indicator \
    --indicator-radius 100 \
    --indicator-thickness 12 \
    --effect-blur 7x5 \
    --ring-color $BTN_BG \
    --key-hl-color $BTN_BG \
    --line-color $BG \
    --inside-color 00000088 \
    --separator-color 00000000 \
    --datestr %d-%m-%Y \
    --text-color $FG \
    --text-caps-lock-color $HDR_BTN_FG \
    --show-failed-attempts \
    --fade-in 0.1 \
    --effect-scale 0.5 --effect-blur 8x3 --effect-scale 2 \
    --effect-vignette 0.5:0.5 \
    --effect-compose="100,-100;40x40;center;${./lock.svg}"
''
