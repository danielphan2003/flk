{ mod, ... }: {
  # Kill focused window
  "Mod1+F4" = "kill";

  "${mod}+h" = "focus left";
  "${mod}+j" = "focus down";
  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";

  "${mod}+Left" = "focus left";
  "${mod}+Down" = "focus down";
  "${mod}+Up" = "focus up";
  "${mod}+Right" = "focus right";

  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";

  "${mod}+Shift+Left" = "move left";
  "${mod}+Shift+Down" = "move down";
  "${mod}+Shift+Up" = "move up";
  "${mod}+Shift+Right" = "move right";

  "${mod}+b" = "splith";
  "${mod}+c" = "splitv";
  "${mod}+f" = "fullscreen toggle";
  "${mod}+a" = "focus parent";

  "${mod}+e" = "layout toggle split";
  "${mod}+w" = "layout tabbed";
  "${mod}+s" = "layout stacking";

  "${mod}+space" = "focus mode_toggle";
  "${mod}+Shift+space" = "floating toggle";

  # Resize window to φ ratio of screen or ½, with:
  #   $φ = 38 ppt;
  #   $Φ = 62 ppt;
  "${mod}+Shift+z" = "exec swaymsg resize set width $φ";
  "${mod}+z" = "exec swaymsg resize set width $Φ";
  "${mod}+Ctrl+z" = "exec swaymsg resize set width 50";
}
