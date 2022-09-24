{
  inputs,
  cell,
}: let
  l = builtins // nixlib.lib;
  inherit (inputs) cells nixlib;
in with inputs; {
  inherit
    (devos-ext-lib.overlays)
    minecraft-mods
    papermc
    python3Packages
    vimPlugins
    vscode-extensions
    ;

  devos-ext-lib = devos-ext-lib.overlays.default;

  nixpkgs-wayland = nixpkgs-wayland.overlays.default;

  gomod2nix = gomod2nix.overlays.default;
}
