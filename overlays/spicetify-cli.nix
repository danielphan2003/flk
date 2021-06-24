final: prev:
let inherit (final.srcs) spicetify-cli-v1 spicetify-cli; in
{
  spicetify-cli = prev.spicetify-cli.overrideAttrs
    (o:
      let src = if o ? legacySupport then spicetify-cli-v1 else spicetify-cli; in
      rec {
        inherit src;
        inherit (src) version;
        postInstall = ''
          cp -r ${src}/jsHelper ${src}/Themes ${src}/Extensions ${src}/CustomApps ${src}/globals.d.ts ${src}/css-map.json $out/bin
        '';
      });

  spotify-unwrapped = prev.spotify-unwrapped.overrideAttrs
    (o:
      let
        version = "1.1.56.595.g2d2da0de";
        rev = "47";
      in
      if o ? legacySupport then {} else
      {
        inherit version;
        src = prev.fetchurl {
          url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
          sha512 = "sha512-V25HGnCdyyELbYQV/EadsDWz8M7Wntbfd9wuBnPc0idDsLi1OJKHe9tozWjXspve3Hmr+hnwVOqBctdly08BxA==";
        };
        unpackPhase = ''
          runHook preUnpack
          unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
          cd squashfs-root
          if ! grep -q 'grade: stable' meta/snap.yaml; then
            # Unfortunately this check is not reliable: At the moment (2018-07-26) the
            # latest version in the "edge" channel is also marked as stable.
            echo "The snap package is marked as unstable:"
            grep 'grade: ' meta/snap.yaml
            echo "You probably chose the wrong revision."
            exit 1
          fi
          runHook postUnpack
        '';
      });
}
