channels: final: prev:
let
  wineOverlay = with prev;
    if prev ? system
    then
      if builtins.elem prev.system [ "i686-linux" "x86_64-linux" ]
      then
        {
          inherit (channels.latest) wineStable wine-staging winePackages wineWowPackages winetricks;

          wine = final.wineWowPackages.staging;

          # wine-wayland = (final.wineWowPackages.stable.overrideDerivation (
          #   { buildInputs ? [ ]
          #   , configureFlags ? [ ]
          #   , makeFlags ? [ ]
          #   , patches ? [ ]
          #   , ...
          #   }: {
          #     inherit (final.sources.wine-wayland) src;
          #     buildInputs = buildInputs ++ (with prev; [
          #       wayland libxkbcommon wayland.dev
          #     ]);
          #     configureFlags = configureFlags ++ [ "--with-wayland" ];
          #     XKBCOMMON_CFLAGS = "-I${prev.libxkbcommon.dev}/include";
          #     XKBCOMMON_LIBS = "-L${prev.libxkbcommon.out}/lib -lxkbcommon";
          #     patches = patches ++ (prev.lib.our.getPatches ../pkgs/misc/emulators/wine);
          #   }
          # )).override {
          #   mingwSupport = true;
          #   vulkanSupport = true;
          # };

          bottles = prev.bottles.overrideAttrs (o: (with final; {
            inherit (sources.bottles) pname src version;
            propagatedBuildInputs = o.propagatedBuildInputs ++ (with python3Packages; [
              pyyaml
              requests
              patool
            ]);
            buildInputs = o.buildInputs ++ [ cabextract dconf ];
            preConfigure = ''
              substituteInPlace build-aux/meson/postinstall.py \
                --replace "'update-desktop-database'" "'${desktop-file-utils}/bin/update-desktop-database'"
              substituteInPlace src/backend/manager.py \
                --replace " {runner}" " ${steam-run-native}/bin/steam-run {runner}" \
                --replace " {dxvk_setup}" " ${steam-run-native}/bin/steam-run {dxvk_setup}"
            '';
          }));
        }
      else
        { }
    else
      { };
in
wineOverlay
