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
    "--enable-vulkan"
    "--ignore-gpu-blocklist"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
  ];

  flags = (prev.lib.optionals enableWayland [
    "--enable-features=UseOzonePlatform"
    "--ozone-platform=wayland"
    "--enable-webrtc-pipewire-capturer"
  ]) ++ extraOptions;

  flagsCommand = prev.lib.concatStringsSep " " flags;

  patchElectron = bin: ''
    # wrapProgram ${bin} \
    #   --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    substituteInPlace ${bin} \
      --replace '"$@"' '${flagsCommand} "$@"'
  '';
in
{

  element-desktop = element-desktop.override { electron = final.electron; };

  discord-canary = discord-canary.overrideAttrs (_: { postFixup = patchElectron "$out/bin/discordcanary"; });

  signal-desktop = signal-desktop.overrideAttrs (o: { postFixup = o.postFixup + patchElectron "$out/bin/signal-desktop-unwrapped"; });

  electron = electron.overrideAttrs (o: { postFixup = o.postFixup + patchElectron "$out/lib/electron/electron"; });

  vscodium = vscodium.overrideAttrs (_: { postInstall = patchElectron "$out/bin/codium"; });

}
