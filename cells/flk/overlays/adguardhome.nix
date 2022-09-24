final: prev: {
  adguardhome = prev.adguardhome.overrideAttrs (o: let
    system = prev.system or prev.stdenv.targetPlatform;
    arch =
      {
        "x86_64-darwin" = "darwin-amd64";
        "i686-linux" = "linux-386";
        "x86_64-linux" = "linux-amd64";
        "aarch64-linux" = "linux-arm64";
      }
      .${system}
      or (throw "Source for ${o.pname} is not available for ${system}");
  in {
    inherit (final.fog."adguardhome-${arch}") src version;
  });
}
