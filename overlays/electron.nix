channels: final: prev:
let
  inherit (channels.latest)
    discord-canary
    element-desktop
    signal-desktop
    teams
    ungoogled-chromium
    vscodium
    ;

  inherit (final)
    electron
    sources
    ;

  inherit (prev)
    makeWrapper
    microsoft-edge-beta
    spotify-spicetified
    symlinkJoin
    writeShellScript
    ;

  inherit (prev.lib)
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    last
    optionals
    splitString
    toList
    ;

  enableWayland = true;

  extraOptions = [
    "--enable-accelerated-mjpeg-decode"
    "--enable-accelerated-video"
    "--enable-gpu-rasterization"
    "--enable-native-gpu-memory-buffers"
    "--enable-vulkan"
    "--enable-zero-copy"
  ];

  waylandFlags = [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ];

  defaultFlags = (optionals enableWayland waylandFlags) ++ extraOptions;

  flagsCommand = concatStringsSep " ";

  compatScript = flags: writeShellScript "electron-compat-flags.sh" ''
    if [[ -n $WAYLAND_DISPLAY ]]
    then
      echo ${flagsCommand flags}
    else
      echo ""
    fi
  '';

  electronCompatFlags = flags: "$(${compatScript flags})";

  patchElectron = bin: { flags ? defaultFlags }:
    let
      # Very hacky, but works nonetheless
      # substitutePhase = "substituteInPlace ${bin'} --replace '$@' '$@\" \"\" \$(${escapeShellArg (compatScript flags)}) \"'";
      wrapper = bin':
        let
          binName = last (splitString "/" bin');
        in
        ''
          mkdir -p $out/.bin-wrapped
          cp --copy-contents ${bin'} $out/.bin-wrapped/${binName}
          rm ${bin'}
          makeWrapper $out/.bin-wrapped/${binName} ${bin'} \
            --add-flags ${escapeShellArg (electronCompatFlags flags)}
        '';
    in
    concatMapStringsSep "\n" (x: wrapper x) (toList bin);

  patchElectronApplication = pkg: bin: { flags ? defaultFlags }:
    (symlinkJoin {
      inherit (pkg) name;
      paths = [ pkg ];
      buildInputs = [ makeWrapper ];
      postBuild = patchElectron bin { inherit flags; };
    }).overrideAttrs (_: {
      inherit (pkg)
        meta
        name
        version
        ;
      pname = pkg.pname or pkg.name;
    });

  patchBrowser = pkg: { flags ? defaultFlags }:
    pkg.override { commandLineArgs = electronCompatFlags flags; };
in
{
  element-desktop = element-desktop.override { inherit electron; };

  discord-canary = patchElectronApplication
    (discord-canary.overrideAttrs (_: { inherit (sources.discord-canary) pname src version; }))
    "$out/opt/DiscordCanary/DiscordCanary"
    { };

  # TODO: signal still uses xwayland
  signal-desktop = patchElectronApplication signal-desktop "$out/bin/signal-desktop" { };

  electron = patchElectronApplication channels.latest.electron "$out/lib/electron/electron" { };

  vscodium = patchElectronApplication vscodium "$out/bin/codium" { };

  ungoogled-chromium = patchBrowser ungoogled-chromium { };

  microsoft-edge-beta = patchBrowser microsoft-edge-beta { };

  spotify-spicetified = patchBrowser spotify-spicetified { flags = waylandFlags; };

  teams = patchElectronApplication
    (teams.overrideAttrs (_: { inherit (sources.teams) src version; }))
    "$out/bin/teams"
    { };

}
