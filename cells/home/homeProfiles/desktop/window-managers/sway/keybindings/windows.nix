{
  services.swhkd.keybindings = {
    # Kill focused window
    "alt + f4" = "exec swaymsg kill";

    "super + {_,shift + }{h,j,k,l}" = "exec swaymsg {focus,move} {left,down,up,right}";

    "super + {_,shift + }{left,down,up,right}" = "exec swaymsg {focus,move} {left,down,up,right}";

    "super + {b,c}" = "exec swaymsg split{h,v}";

    "super + f" = "exec swaymsg fullscreen toggle";

    "super + a" = "exec swaymsg focus parent";

    # "super + {e,w,s}" = "exec swaymsg layout {toggle split,tabbed,stacking}";

    "super + space" = "exec swaymsg focus mode_toggle";

    "super + shift + space" = "exec swaymsg floating toggle";

    # Resize window to φ, or ½, or Φ, ratio of screen, with:
    #   $φ = 38 ppt
    #   $Φ = 62 ppt
    "super + {shift + ,ctrl + ,_}z" = "exec swaymsg resize set width \\\${φ,50,Φ}";
  };
}
