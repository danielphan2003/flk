{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      clipman
      dmenu
      flameshot
      grim
      slurp
      swaybg
      tdrop
      wdisplays
      wf-recorder
      wl-clipboard
      wlvncc
      wlr-randr
      wlrctl
      wofi
      wtype
      ;
  };
}
