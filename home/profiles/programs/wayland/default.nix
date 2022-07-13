{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      clipman
      dmenu
      flameshot
      grim
      mako
      nwg-drawer
      nwg-launchers
      nwg-menu
      nwg-panel
      nwg-wrapper
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
