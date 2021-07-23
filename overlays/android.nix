channels: final: prev: {
  # track https://github.com/NixOS/nixpkgs/pull/125600
  inherit (channels.anbox)
    anbox
    anbox-postmarketos-image
    # buildLinux
    ;

  # linuxPackagesFor = kernel:
  #   (prev.linuxPackagesFor kernel).makeExtensible (self: with self; rec {
  #     anbox = self.callPackage anbox-module { };
  #   });

  inherit (channels.latest)
    android-tools
    lxc
    ;

  # android-desktop = prev.writeShellScriptBin "android-desktop" ''
  #   ${prev.podman}/bin/podman run -it \
  #     --privileged \
  #     --device /dev/kvm \
  #     -v /tmp/.X11-unix:/tmp/.X11-unix \
  #     -e "DISPLAY=''${DISPLAY:-:0.0}" \
  #     -p 5555:5555 \
  #     -p 50922:10022 \
  #     --device=/dev/dri \
  #       --group-add video \
  #       -e EXTRA='-display none -vnc 0.0.0.0:99,password=off' \
  #     --device /dev/snd \
  #     sickcodes/dock-droid:latest
  # '';

  android-desktop = prev.writeTextDir "share/applications/android.desktop" ''
    [Desktop Entry]
    Name=Android
    Type=Application
    Exec=${prev.podman}/bin/podman container start android
  '';
}
