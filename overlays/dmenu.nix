final: prev: {
  dmenu = prev.dmenu.overrideAttrs
    (
      o: {
        name = "dmenu-5.0";
        src = prev.fetchurl {
          url = "https://dl.suckless.org/tools/dmenu-5.0.tar.gz";
          sha256 = "1lvfxzg3chsgcqbc2vr0zic7vimijgmbvnspayx73kyvqi1f267y";
        };
      }
    ) // prev.dmenu.override { patches = [ ]; };
}
