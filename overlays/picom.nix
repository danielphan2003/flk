final: prev: {
  picom =
    (prev.picom.overrideAttrs
      (_:
        let src = final.srcs.picom;
        in
        {
          inherit src;
          inherit (src) version;
        })
    ).override { stdenv = prev.clangStdenv; };
}
