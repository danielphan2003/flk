final: prev: {
  spicetify-cli = prev.spicetify-cli.overrideAttrs (_: {
    inherit (final.fog.spicetify-cli) pname version src;
    postInstall = ''
      cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin
    '';
  });

  spotify-unwrapped = prev.spotify-unwrapped.overrideAttrs (o: {
    inherit (final.fog.spotify) src version;

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

    meta = o.meta // {mainProgram = "spotify";};
  });

  spotify-unwrapped-1_1_83_954_gd226dfe8 = final.spotify-unwrapped.overrideAttrs (_: {
    inherit (final.fog.spotify-1_1_83_954_gd226dfe8) src version;
  });

  spotifyd = prev.spotifyd.override {
    rustPackages.rustPlatform.buildRustPackage = attrs: let
      attrs' = builtins.removeAttrs attrs ["cargoSha256"];
      overrideAttrs = {
        inherit (final.fog.spotifyd) src version;
        cargoLock = final.fog.spotifyd.cargoLock."Cargo.lock";
      };
    in
      final.rustPackages.rustPlatform.buildRustPackage (attrs' // overrideAttrs);
  };

  # spotify-spiced = final.electron-utils.wrapBrowser prev.spotify-spiced {
  #   extraFlags = ["--enable-devtool" "--enable-developer-mode"];
  # };

  # my-spotify-spiced = final.spotify-spiced.override {
  #   spotify-unwrapped = final.spotify-unwrapped-1_1_83_954_gd226dfe8; # pin spotify to known version that works with dribbblish-dynamic
  #   theme = "ddt";
  #   injectCss = true;
  #   replaceColors = true;
  #   overwriteAssets = true;
  #   customThemes = {
  #     "ddt" = "${pkgs.dribbblish-dynamic-theme}/theme";
  #   };
  #   customExtensions = {
  #     "ddt.js" = "${pkgs.dribbblish-dynamic-theme}/extensions/dribbblish-dynamic.js";
  #   };
  #   customApps = {
  #     "marketplace" = "${final.spicetify-marketplace}/custom_apps";
  #   };
  #   enabledCustomApps = [
  #     "marketplace"
  #     "lyrics-plus"
  #     "new-releases"
  #     "reddit"
  #   ];
  #   enabledExtensions = [
  #     # "ddt.js"
  #     "fullAppDisplay.js"
  #     "loopyLoop.js"
  #     "popupLyrics.js"
  #     "shuffle+.js"
  #     "trashbin.js"
  #   ];
  #   extraConfig = ''
  #     [Patch]
  #     xpui.js_find_8008 = ,(\w+=)32,
  #     xpui.js_repl_8008 = ,''${1}58,
  #   '';
  # };

  psst = prev.psst.override {
    rustPlatform.buildRustPackage = args: let
      version = "f1300bf5684f7c57dfab718e9e7b1cd8c6091b69";

      src = final.fetchFromGitHub {
        owner = "jpochyla";
        repo = args.pname;
        rev = version;
        sha256 = "sha256-puXwU0iXt1mgQsVfLBVvkrZMpp/Zn4EKB5zyqSmHRI4=";
      };

      cargoLock = {
        lockFile = "${src}/Cargo.lock";
        outputHashes = {
          "druid-0.7.0" = "sha256-0bgPD4aYDiMnVmqaGALfqptDhQ9r3u7txeXNSiqeozI=";
          "druid-enums-0.1.0" = "sha256-4fo0ywoK+m4OuqYlbNbJS2BZK/VBFqeAYEFNGnGUVmM=";
          "piet-0.5.0" = "sha256-hCg8vABnLAO8egFwMtRSpRdzH6auETrICoUfuBZVzz8=";
        };
      };
    in
      final.rustPlatform.buildRustPackage (builtins.removeAttrs args ["cargoSha256" "version"]
        // {
          inherit version src cargoLock;

          postInstall = ''
            install -Dm444 psst-gui/assets/logo_512.png $out/share/icons/${args.pname}.png
          '';

          meta.mainProgram = "psst-gui";
        });
  };

  # spot = prev.spot.overrideAttrs (_: {
  #   version =

  #   src = final.fetchFromGitHub {
  #     owner = "xou816";
  #     repo = "spot";
  #     rev = version;
  #     hash = "sha256-0iuLZq9FSxaOchxx6LzGwpY8qnOq2APl/qkBYzEV2uw=";
  #   };

  #   cargoDeps = final.rustPlatform.fetchCargoTarball {
  #     inherit src;
  #     name = "${pname}-${version}";
  #     hash = "sha256-g46BkrTv6tdrGe/p245O4cBoPjbvyRP7U6hH1Hp4ja0=";
  #   };

  # });
}
