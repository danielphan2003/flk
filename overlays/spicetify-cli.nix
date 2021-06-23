final: prev: {
  spicetify-cli = { legacySupport ? false }:
    prev.spicetify-cli.overrideAttrs
      (_:
        let src = final.srcs.spicetify-cli;
        in
        if legacySupport then {
          inherit src;
          inherit (src) version;
          preInstall = ''
            mkdir -p $out/share/spicetify
            cp -r $src/Themes $out/share/spicetify
          '';
        }
        else { });
  spotify-unwrapped-beta = prev.spotify-unwrapped.overrideAttrs
    (_:
      let
        version = "1.1.56.595.g2d2da0de";
        rev = "47";
      in
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
