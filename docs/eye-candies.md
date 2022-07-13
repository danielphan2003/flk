## Eye candies and what not

- Pywal theming:

  - Very helpful wallpaper setting [script][wal-set]. It reloads pywalfox, sway border colors, along with seamless wallpaper switching and notify user when everything is done.

- Gnome: bare minimum for now.

- Systemd-Networkd: remove the need for NetworkManager (it sucks anyway).

- X11:

  - AwesomeWM: formatted and based on [the-glorious-dotfiles].

- Wayland:
  - Latest packages from [nixpkgs-wayland].
  - Latest ibus, ibus-bamboo, and ibus-uniemoji work [flawlessly][sway-startup]. Adapted from Arch Wiki's Ibus [integration][arch-wiki-ibus-integration]. Note that shortcut for switching inputs only works on X11 apps, but you can still type normally on Wayland (not with in native Electron apps though). An [eww] bar might fix this.
  - Helpful [Waybar module maker][waybar-module-maker]. See [waybar-modules].
  - Working [vnc][wayvnc-hm] module (and keymap passthrough?) with [wayvnc].
  - (very MUCH wip) [river] declarative config.

[arch-wiki-ibus-integration]: https://wiki.archlinux.org/title/IBus#Integration
[eww]: https://github.com/elkowar/eww
[nixpkgs-wayland]: https://github.com/colemickens/nixpkgs-wayland
[river]: https://github.com/ifreund/river
[sway-startup]: ../home/profiles/graphical/sway/config/startup.nix#L17-L20
[the-glorious-dotfiles]: https://github.com/manilarome/the-glorious-dotfiles
[wal-set]: ../home/profiles/graphical/sway/config/scripts/wal-set.nix
[waybar-modules]: ../home/profiles/graphical/sway/waybar/modules
[waybar-module-maker]: ../lib/pkgs-build/mkWaybarModule.nix
[wayvnc]: https://github.com/any1/wayvnc
[wayvnc-hm]: ../home/modules/services/misc/wayvnc.nix
