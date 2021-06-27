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
in
{
  element-desktop = element-desktop.override { electron = final.electron; };

  discord-canary = discord-canary.overrideAttrs (_: {
    postFixup = ''
      substituteInPlace $out/bin/discordcanary \
        --replace '"$@"' '${flagsCommand} "$@"'
    '';
  });

  signal-desktop = signal-desktop.overrideAttrs (o: {
    postFixup = ''
      ${o.postFixup}
      substituteInPlace $out/bin/signal-desktop-unwrapped \
        --replace '"$@"' '${flagsCommand} "$@"'
    '';
  });

  electron = electron.overrideAttrs (o: {
    postFixup = ''
      ${o.postFixup}
      # Create electron wrapper
      substituteInPlace $out/lib/electron/electron \
        --replace '"$@"' '${flagsCommand} "$@"'
    '';
  });

  vscodium = vscodium.overrideAttrs (_: {
    postInstall = ''
      substituteInPlace $out/bin/codium \
        --replace '"$@"' '${flagsCommand} "$@"'
    '';
  });
}