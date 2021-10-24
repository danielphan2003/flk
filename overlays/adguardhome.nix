final: prev: {
  adguardhome =
    let
      system = prev.system or prev.stdenv.targetPlatform;
      arch = {
        "x86_64-darwin" = "darwin-amd64";
        "i686-linux" = "linux-386";
        "x86_64-linux" = "linux-amd64";
        "aarch64-linux" = "linux-arm64";
      }.${system};
    in prev.adguardhome.overrideAttrs (_: {
      inherit (final.sources."adguardhome-${arch}") src version;
      meta = with prev.lib; {
        platforms = platforms.unix;
        license = licenses.gpl3Only;
      };
    });
}
