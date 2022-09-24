{lib}: {
  hyprland = import ./hyprland.nix {inherit lib;};
  i3wm = import ./i3wm.nix {inherit lib;};
}
