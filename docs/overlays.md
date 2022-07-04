# Overlays

Here come some helpful overlays:

- [electron-compat][electron-compat]: a compat layer that makes Electron apps run natively on X11 and Wayland.
  Apps are wrapped with a Bash script that evals to platform-specific flags. To prevent double wrapping `$out/.bin-wrapped` is used so that application name shows up correctly in htop or other programs.

[electron-compat]: ../overlays/electron.nix
