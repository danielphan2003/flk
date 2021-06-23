final: prev: {
  sway = prev.sway.override {
    sway-unwrapped = (prev.sway-unwrapped.overrideAttrs
      (_:
        let src = final.srcs.sway-borders;
        in
        {
          inherit src;
          inherit (src) version;
          # patches = [ ../pkgs/applications/window-managers/sway-borders/dont-restart-swaybg-if-the-command-hasnt-changed.patch ];
        })
    ).override { wlroots = final.waylandPkgs.wlroots; };
  };
}
