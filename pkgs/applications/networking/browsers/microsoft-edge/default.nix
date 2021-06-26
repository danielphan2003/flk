{ stdenv, lib, binutils-unwrapped, sources
, xz, gnutar, file, glibc, glib, nss, nspr
, atk, at_spi2_atk, xorg, cups, dbus_libs, expat
, libdrm, libxkbcommon, gnome3, gnome2, cairo, gdk-pixbuf
, mesa, alsaLib, at_spi2_core, libuuid

, channel ? "beta"
}:
stdenv.mkDerivation rec {
  pname = "microsoft-edge-${channel}";
  inherit (sources."${pname}") src version;

  unpackCmd = ''
    mkdir -p microsoft-edge-${channel}-${version}
    ${binutils-unwrapped}/bin/ar p $src data.tar.xz | ${xz}/bin/xz -dc | ${gnutar}/bin/tar -C microsoft-edge-${channel}-${version} -xf -
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R opt usr/bin usr/share $out

    ln -sf $out/opt/microsoft/msedge-${channel}/microsoft-edge-${channel} $out/opt/microsoft/msedge-${channel}/microsoft-edge
    ln -sf $out/opt/microsoft/msedge-${channel}/microsoft-edge-${channel} $out/bin/microsoft-edge-${channel}

    rm -rf $out/share/doc
    rm -rf $out/opt/microsoft/msedge-${channel}/cron

    substituteInPlace $out/bin/microsoft-edge-${channel} \
      --replace "exec -a" "LD_LIBRARY_PATH=/run/current-system/sw/lib exec -a"

    substituteInPlace $out/share/applications/microsoft-edge-${channel}.desktop \
      --replace "/usr/bin/microsoft-edge-${channel}" "$out/bin/microsoft-edge-${channel}"

    substituteInPlace $out/share/gnome-control-center/default-apps/microsoft-edge-${channel}.xml \
      --replace /opt/microsoft/msedge-${channel} $out/opt/microsoft/msedge-${channel}

    substituteInPlace $out/share/menu/microsoft-edge-${channel}.menu \
      --replace /opt/microsoft/msedge-${channel} $out/opt/microsoft/msedge-${channel}

    substituteInPlace $out/opt/microsoft/msedge-${channel}/xdg-mime \
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "xdg_system_dirs=/usr/local/share/:/usr/share/" "xdg_system_dirs=/run/current-system/sw/share/" \
      --replace /usr/bin/file ${file}/bin/file

    substituteInPlace $out/opt/microsoft/msedge-${channel}/default-app-block \
      --replace /opt/microsoft/msedge-${channel} $out/opt/microsoft/msedge-${channel}

    substituteInPlace $out/opt/microsoft/msedge-${channel}/xdg-settings \
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "''${XDG_CONFIG_DIRS:-/etc/xdg}" "''${XDG_CONFIG_DIRS:-/run/current-system/sw/etc/xdg}"
  '';

  preFixup =
    let
      libPath = {
        msedge = lib.makeLibraryPath [
          glibc
          glib
          nss
          nspr
          atk
          at_spi2_atk
          xorg.libX11
          xorg.libxcb
          cups.lib
          dbus_libs.lib
          expat
          libdrm
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          libxkbcommon
          gnome3.gtk
          gnome2.pango
          cairo
          gdk-pixbuf
          mesa
          alsaLib
          at_spi2_core
          xorg.libxshmfence
        ];
        naclHelper = lib.makeLibraryPath [
          glib
        ];
        libwidevinecdm = lib.makeLibraryPath [
          glib
          nss
          nspr
        ];
        libGLESv2 = lib.makeLibraryPath [
          xorg.libX11
          xorg.libXext
          xorg.libxcb
        ];
        libsmartscreen = lib.makeLibraryPath [
          libuuid
          stdenv.cc.cc.lib
        ];
      };
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath.msedge}" \
        $out/opt/microsoft/msedge-${channel}/msedge

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/opt/microsoft/msedge-${channel}/msedge-sandbox

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/opt/microsoft/msedge-${channel}/crashpad_handler

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath.naclHelper}" \
        $out/opt/microsoft/msedge-${channel}/nacl_helper

      patchelf \
        --set-rpath "${libPath.libwidevinecdm}" \
        $out/opt/microsoft/msedge-${channel}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

      patchelf \
        --set-rpath "${libPath.libGLESv2}" \
        $out/opt/microsoft/msedge-${channel}/libGLESv2.so

      patchelf \
        --set-rpath "${libPath.libsmartscreen}" \
        $out/opt/microsoft/msedge-${channel}/libsmartscreen.so
    '';

  meta = with lib; {
    homepage = "https://www.microsoftedgeinsider.com/en-us/";
    description = "Microsoft's fork of Chromium web browser";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [
      {
        name = "Azure Zanculmarktum";
        email = "zanculmarktum@gmail.com";
      }
    ];
  };
}
