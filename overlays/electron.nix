channels: final: prev: let
  inherit
    (prev)
    discord-canary
    element-desktop
    signal-desktop
    teams
    ungoogled-chromium
    vscodium
    ;

  inherit
    (final)
    callPackage
    makeWrapper
    electron
    sources
    symlinkJoin
    wlroots
    writeShellScript
    ;

  inherit
    (prev)
    electron_16
    microsoft-edge-beta
    spotify-spicetified
    ;

  inherit
    (prev.lib)
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    last
    optionals
    splitString
    toList
    ;

  inherit (builtins) compareVersions;

  # see https://github.com/NixOS/nixpkgs/issues/137688
  # chromium >= 96.0.4664.55 and electron >= 16.0.2 should fix this
  # note that proprietary packages like Spotify does not have this patch yet
  # at least Xwayland works without patching
  # see also ./waylandPkgs.nix
  enableWayland = true;
  # enableWayland = (compareVersions ungoogled-chromium.version "96.0.4664.45" >= 0
  #   && compareVersions electron_16.version "16.0.2" >= 0)
  #   || (wlroots.patchedChromium or false);

  extraOptions = [
    "--enable-accelerated-mjpeg-decode"
    "--enable-accelerated-video"
    "--enable-gpu-rasterization"
    "--enable-native-gpu-memory-buffers"
    "--enable-vulkan"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"
  ];

  waylandFlags = optionals enableWayland [
    "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    "--enable-webrtc-pipewire-capturer"
    "--ozone-platform=wayland"
  ];

  defaultFlags = waylandFlags ++ extraOptions;

  flagsCommand = concatStringsSep " ";

  compatScript = flags:
    writeShellScript "electron-compat-flags.sh" ''
      if [[ -n $WAYLAND_DISPLAY ]]
      then
        echo ${flagsCommand flags}
      else
        echo ""
      fi
    '';

  electronCompatFlags = flags: "$(${compatScript flags})";

  patchElectron = bin: {flags ? defaultFlags}: let
    wrapper = bin': let
      binName = last (splitString "/" bin');
    in ''
      mkdir -p $out/.bin-wrapped
      cp --copy-contents ${bin'} $out/.bin-wrapped/${binName}
      rm ${bin'}
      makeWrapper $out/.bin-wrapped/${binName} ${bin'} \
        --add-flags ${escapeShellArg (electronCompatFlags flags)}
    '';
  in
    concatMapStringsSep "\n" (x: wrapper x) (toList bin);

  patchElectronApplication = drv: bin: {flags ? defaultFlags}:
    (symlinkJoin {
      inherit (drv) name;
      paths = [drv];
      buildInputs = [makeWrapper];
      postBuild = patchElectron bin {inherit flags;};
    })
    .overrideAttrs (_: {
      inherit
        (drv)
        meta
        name
        version
        ;
      pname = drv.pname or drv.name;
    });

  patchBrowser = drv: {flags ? defaultFlags}:
    drv.override {commandLineArgs = electronCompatFlags flags;};
in {
  element-desktop = element-desktop; # .override { inherit electron; };

  discord-canary =
    patchElectronApplication
    (discord-canary.overrideAttrs (_: {inherit (sources.discord-canary) pname src version;}))
    "$out/opt/DiscordCanary/DiscordCanary"
    {};

  # TODO: signal still uses xwayland
  signal-desktop = patchElectronApplication signal-desktop "$out/bin/signal-desktop" {};

  electron = final.electron_16;

  electron_16 = patchElectronApplication electron_16 "$out/lib/electron/electron" {};

  vscodium = patchElectronApplication vscodium "$out/bin/codium" {};

  ungoogled-chromium = patchBrowser ungoogled-chromium {};

  microsoft-edge-beta = patchBrowser microsoft-edge-beta {};

  spotify-spicetified = patchBrowser spotify-spicetified {
    flags = waylandFlags ++ ["--enable-devtool" "--enable-developer-mode"];
  };

  teams =
    # patchElectronApplication
    teams.overrideAttrs (_: {inherit (sources.teams) src version;})
    # "$out/bin/teams"
    # {}
    ;
}
