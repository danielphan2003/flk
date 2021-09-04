channels: final: prev: {
  # wine-staging = channels.latest.wine.override {
  #   wineRelease = "staging";
  #   wineBuild = "wineWow";
  #   callPackage = path: args: with prev;
  #     let package = callPackage path args; in
  #     if package ? overrideAttrs
  #     then
  #       (package.overrideAttrs (o: {
  #         buildInputs = o.buildInputs ++ [ wayland egl-wayland libxkbcommon ];
  #       })).override
  #         {
  #           inherit (final.sources.wine-wayland) src;
  #           configureFlags = [ "--with-wayland" "--with-vulkan" "--with-vkd3d" ];
  #         }
  #     else package;
  # };
}
