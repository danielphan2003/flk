final: prev: {
  sway = prev.sway.override {
    sway-unwrapped = (prev.sway-unwrapped.overrideAttrs
      (_:
        let src = final.srcs.sway-borders;
        in
        {
          inherit src;
          inherit (src) version;
        })
    ).override { wlroots = final.waylandPkgs.wlroots; };
  };
}
