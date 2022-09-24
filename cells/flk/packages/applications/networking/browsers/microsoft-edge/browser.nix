# Which distribution channel to use.
{channel}: {
  lib,
  stdenv,
  makeWrapper,
  fog,
  binutils-unwrapped,
  xz,
  gnutar,
  # Linked dynamic libraries.
  glibc,
  glib,
  fontconfig,
  freetype,
  pango,
  cairo,
  atk,
  nss,
  nspr,
  xorg,
  alsa-lib,
  file,
  expat,
  cups,
  dbus,
  gtk3,
  gdk-pixbuf,
  at-spi2-atk,
  at-spi2-core,
  libdrm,
  mesa,
  libuuid,
  libxkbcommon,
  # ozone/wayland
  wayland,
  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",
  # Will crash without.
  systemd,
  # Loaded at runtime.
  libexif,
  # Additional dependencies according to other distros.
  ## Ubuntu
  liberation_ttf,
  # Necessary for USB audio devices.
  # pulseSupport ? true,
  # libpulseaudio ? null,
  # gsettings-desktop-schemas,
  # gnome,
  # # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
  # libvaSupport ? true,
  # libva,
  # # For Vulkan support (--enable-features=Vulkan)
  # vulkanSupport ? true,
  # vulkan-loader,
}: let
  libPath = {
    msedge = {
      rpath =
        [
          fontconfig
          freetype
          libexif
          liberation_ttf
          glibc
          glib
          nss
          nspr
          atk
          at-spi2-atk
          xorg.libX11
          xorg.libxcb
          cups.lib
          dbus.lib
          expat
          libdrm
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          libxkbcommon
          gtk3
          pango
          cairo
          gdk-pixbuf
          mesa
          alsa-lib
          at-spi2-core
          xorg.libxshmfence
          systemd
          wayland
        ]
        # ++ optional pulseSupport libpulseaudio
        # ++ optional libvaSupport libva
        # ++ optional vulkanSupport vulkan-loader
        ;
      interpreter = true;
    };
    msedge-sandbox.interpreter = true;
    msedge_crashpad_handler.interpreter = true;
    nacl_helper = {
      rpath = [
        glib
        nspr
        atk
        libdrm
        xorg.libxcb
        mesa
        xorg.libX11
        xorg.libXext
        dbus.lib
        libxkbcommon
      ];
      interpreter = true;
    };
    "WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so".rpath = [
      glib
      nss
      nspr
    ];
    "libGLESv2.so".rpath = [
      xorg.libX11
      xorg.libXext
      xorg.libxcb
      wayland
    ];
    "libsmartscreen.so".rpath = [
      libuuid
      stdenv.cc.cc.lib
    ];
    "libsmartscreenn.so".rpath = [
      libuuid
    ];
    "liboneauth.so".rpath = [
      libuuid
      xorg.libX11
    ];
  };

  setPatchelf = {
    path,
    interpreter ? false,
    rpath ? [],
  }:
    assert lib.asserts.assertMsg (rpath != [] || interpreter == true)
    "[microsoft-edge#setPatchelf]: Either rpath should not be empty, or interpreter should be true!"; ''
      patchelf \
        ${lib.optionalString interpreter ''--set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"''} \
        ${lib.optionalString (rpath != []) ''--set-rpath "${lib.makeLibraryPath rpath}"''} \
        opt/microsoft/${shortName}/${path}
    '';

  baseName = "microsoft-edge";

  shortName =
    if channel == "stable"
    then "msedge"
    else "msedge-" + channel;

  longName =
    if channel == "stable"
    then baseName
    else baseName + "-" + channel;

  iconSuffix =
    if channel == "stable"
    then ""
    else "_${channel}";

  desktopSuffix =
    if channel == "stable"
    then ""
    else "-${channel}";
in
  stdenv.mkDerivation {
    inherit (fog."${longName}") pname src version;

    unpackCmd = "${binutils-unwrapped}/bin/ar p $src data.tar.xz | ${xz}/bin/xz -dc | ${gnutar}/bin/tar -xf -";
    sourceRoot = ".";

    dontPatch = true;
    dontConfigure = true;
    dontPatchELF = true;

    nativeBuildInputs = [makeWrapper];

    buildPhase = ''
      ${lib.concatMapStringsSep "\n" (path: setPatchelf ({inherit path;} // libPath.${path})) (builtins.attrNames libPath)}
    '';

    installPhase = ''
      mkdir -p $out $out/.bin-wrapped
      cp -R opt usr/bin usr/share $out

      ${
        if channel == "stable"
        then ""
        else "ln -sf $out/opt/microsoft/${shortName}/${baseName}-${channel} $out/opt/microsoft/${shortName}/${baseName}"
      }

      ln -sf $out/opt/microsoft/${shortName}/${longName} $out/bin/${longName}

      ln -s $out/opt/microsoft/${shortName}/msedge $out/.bin-wrapped/msedge

      # To fix --use-gl=egl:
      test -e $out/opt/microsoft/${shortName}/libEGL.so
      ln -s libEGL.so $out/opt/microsoft/${shortName}/libEGL.so.1
      test -e $out/opt/microsoft/${shortName}/libGLESv2.so
      ln -s libGLESv2.so $out/opt/microsoft/${shortName}/libGLESv2.so.2

      rm -rf $out/share/doc
      rm -rf $out/opt/microsoft/${shortName}/cron

      for icon in '16' '24' '32' '48' '64' '128' '256'
      do
        ${"icon_source=$out/opt/microsoft/${shortName}/product_logo_\${icon}${iconSuffix}.png"}
        ${"icon_target=$out/share/icons/hicolor/\${icon}x\${icon}/apps"}
        mkdir -p $icon_target
        cp $icon_source $icon_target/microsoft-edge${desktopSuffix}.png
      done

      substituteInPlace $out/share/applications/${longName}.desktop \
        --replace /usr/bin/${longName} $out/bin/${longName}

      substituteInPlace $out/share/gnome-control-center/default-apps/${longName}.xml \
        --replace /opt/microsoft/${shortName}/${longName} $out/bin/${longName}

      substituteInPlace $out/share/menu/${longName}.menu \
        --replace /opt $out/share \
        --replace $out/share/microsoft/${shortName}/${longName} $out/bin/${longName}

      substituteInPlace $out/opt/microsoft/${shortName}/xdg-mime \
        --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
        --replace "xdg_system_dirs=/usr/local/share/:/usr/share/" "xdg_system_dirs=/run/current-system/sw/share/" \
        --replace /usr/bin/file ${file}/bin/file

      substituteInPlace $out/opt/microsoft/${shortName}/default-app-block \
        --replace /opt/microsoft/${shortName} $out/opt/microsoft/${shortName}

      substituteInPlace $out/opt/microsoft/${shortName}/xdg-settings \
        --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
        --replace "''${XDG_CONFIG_DIRS:-/etc/xdg}" "''${XDG_CONFIG_DIRS:-/run/current-system/sw/etc/xdg}"

      substituteInPlace "$out/bin/${longName}" \
        --replace '"$@"' '${lib.escapeShellArg commandLineArgs} "$@"'
    '';

    meta = with lib; {
      homepage = "https://www.microsoft.com/en-us/edge";
      description = "The web browser from Microsoft";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      maintainers = with maintainers; [zanculmarktum kuwii];
    };
  }
