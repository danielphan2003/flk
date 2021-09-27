channels: final: prev:
let
  inherit (channels.latest)
    discord-canary
    element-desktop
    signal-desktop
    electron
    teams
    ungoogled-chromium
    vscodium
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

  waylandOptions = [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ];

  flags = (prev.lib.optionals enableWayland waylandOptions) ++ extraOptions;

  flagsCommand = prev.lib.concatStringsSep " ";

  patchElectron = flags': bin: ''
    substituteInPlace ${bin} \
      --replace '"$@"' '"$(if [ ! -n $WAYLAND_DISPLAY ]; then echo ""; else echo "${flagsCommand flags'}"; fi)" "$@"'
  '';
in
{

  element-desktop = element-desktop.override { inherit (final) electron; };

  discord-canary = discord-canary.overrideAttrs (_: {
    inherit (final.sources.discord-canary) pname src version;
    postFixup = patchElectron flags "$out/bin/discordcanary";
  });

  signal-desktop = signal-desktop.overrideAttrs (o: { postFixup = patchElectron flags "$out/bin/signal-desktop"; });

  electron = electron.overrideAttrs (o: { postFixup = o.postFixup + patchElectron flags "$out/lib/electron/electron"; });

  vscodium = vscodium.overrideAttrs (_: { postInstall = patchElectron flags "$out/bin/codium"; });

  ungoogled-chromium = ungoogled-chromium.override { commandLineArgs = flagsCommand waylandOptions; };

  microsoft-edge-beta = prev.microsoft-edge-beta.override { commandLineArgs = flagsCommand flags; };

  microsoft-edge-dev = prev.microsoft-edge-dev.override { commandLineArgs = flagsCommand flags; };

  spotify-spicetified = prev.spotify-spicetified.override {
    commandLineArgs = flagsCommand waylandOptions;
  };

  teams = teams.overrideAttrs (_: {
    inherit (final.sources.teams) src version;
    postDist = patchElectron flags "$out/bin/teams";
  });

}
