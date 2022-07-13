{
  services.sxhkd.keybindings = {
    # Kill focused window
    "alt + f4" = "swaymsg kill";

    "super + {_,shift + }{h,j,k,l}" = "swaymsg {focus,move} {left,down,up,right}";

    "super + {_,shift + }{left,down,up,right}" = "swaymsg {focus,move} {left,down,up,right}";

    "super + {b,c}" = "swaymsg split{h,v}";

    "super + f" = "swaymsg fullscreen toggle";

    "super + a" = "swaymsg focus parent";

    # "super + {e,w,s}" = "swaymsg layout {toggle split,tabbed,stacking}";

    "super + {_,shift +}space" = "swaymsg {focus mode_,floating }toggle";

    # Resize window to φ, or ½, or Φ, ratio of screen, with:
    #   $φ = 38 ppt
    #   $Φ = 62 ppt
    "super + {shift +,ctrl +,_}z" = "swaymsg resize set width '\${φ,50,Φ}'";
  };
}
