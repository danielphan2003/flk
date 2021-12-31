channels: final: prev: {
  # wine = final.wineWowPackages.staging;

  # bottles = prev.bottles.overrideAttrs (o: {
  #   inherit (final.sources.bottles) pname src version;

  #   propagatedBuildInputs = o.propagatedBuildInputs ++ builtins.attrValues {
  #     inherit (prev.python3Packages)
  #       pyyaml
  #       requests
  #       patool
  #     ;
  #   };

  #   buildInputs = o.buildInputs ++ [ prev.cabextract prev.dconf ];

  #   preConfigure = ''
  #     substituteInPlace build-aux/meson/postinstall.py \
  #       --replace "'update-desktop-database'" "'${prev.desktop-file-utils}/bin/update-desktop-database'"
  #     substituteInPlace src/backend/manager.py \
  #       --replace " {runner}" " ${prev.steam-run-native}/bin/steam-run {runner}" \
  #       --replace " {dxvk_setup}" " ${prev.steam-run-native}/bin/steam-run {dxvk_setup}"
  #   '';
  # });
}
