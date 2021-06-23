final: prev: {
  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs
    (o:
      let src = final.srcs.xdg-desktop-portal-wlr;
      in
      {
        inherit src;
        inherit (src) version;
        buildInputs = [ final.libinih ] ++ o.buildInputs;
      });
}
