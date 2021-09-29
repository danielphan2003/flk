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
    electronCompatFlags
    electron
    sources
    ;

  inherit (prev)
    microsoft-edge-beta
    spotify-spicetified
    writeShellScript
    ;

  inherit (prev.lib)
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    optionals
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

  # TODO: prevent double wrapping
  patchElectron = bin: { flags ? defaultFlags }:
    let
      wrapper = bin': ''
        wrapProgram ${bin'} \
          --add-flags ${escapeShellArg (electronCompatFlags flags)}
      '';
    in
    concatMapStringsSep "\n" (x: wrapper x) (toList bin);

  patchElectronApplication = pkg: bin: { flags ? defaultFlags, patchStage ? "postFixup", ... }@args:
    pkg.overrideAttrs (o: args // {
      "${patchStage}" = (o."${patchStage}" or "")
        + patchElectron bin { inherit flags; };
    });

  patchBrowser = pkg: { flags ? defaultFlags }:
    pkg.override { commandLineArgs = electronCompatFlags flags; };
in
{
  electronCompatFlags = flags:
    let
      compatScript = writeShellScript "electron-compat-flags.sh" ''
        if [[ -n $WAYLAND_DISPLAY ]]
        then
          echo '${flagsCommand flags}'
        else
          echo ""
        fi
      '';
    in
    "$(${compatScript})";

  element-desktop = element-desktop.override { inherit electron; };

  discord-canary = patchElectronApplication discord-canary [ "$out/bin/DiscordCanary" "$out/bin/discordcanary" ] {
    inherit (sources.discord-canary) pname src version;
  };

  signal-desktop = patchElectronApplication signal-desktop "$out/bin/signal-desktop" { };

  electron = patchElectronApplication channels.latest.electron "$out/lib/electron/electron" { };

  vscodium = patchElectronApplication vscodium "$out/bin/codium" { };

  ungoogled-chromium = patchBrowser ungoogled-chromium { };

  microsoft-edge-beta = patchBrowser microsoft-edge-beta { };

  spotify-spicetified = patchBrowser spotify-spicetified { flags = waylandFlags; };

  teams = patchElectronApplication teams "$out/bin/teams" {
    inherit (sources.teams) src version;
  };

}
