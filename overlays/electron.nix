channels: final: prev:
let
  inherit (channels.latest)
    discord-canary
    element-desktop
    signal-desktop
    electron
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
    "--ignore-gpu-blocklist"
  ];

  flags = (prev.lib.optionals enableWayland [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ]) ++ extraOptions;

  flagsCommand = prev.lib.concatStringsSep " " flags;

  patchElectron = bin: ''
    substituteInPlace ${bin} \
      --replace '"$@"' '${flagsCommand} "$@"'
  '';
in
{

  element-desktop = element-desktop.override { inherit (final) electron; };

  discord-canary = discord-canary.overrideAttrs (_: rec {
    inherit (final.sources.discord-canary) pname src version;
    postFixup = patchElectron "$out/bin/discordcanary";
  });

  signal-desktop = signal-desktop.overrideAttrs (o: { postFixup = patchElectron "$out/bin/signal-desktop"; });

  electron = electron.overrideAttrs (o: { postFixup = o.postFixup + patchElectron "$out/lib/electron/electron"; });

  vscodium = vscodium.overrideAttrs (_: { postInstall = patchElectron "$out/bin/codium"; });

}
