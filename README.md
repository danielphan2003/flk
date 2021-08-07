# My uwu dotfiles - flaky flake flk

## File structure

Quite different from normal [devos][devos] structure:

```
/
├── .github/
├── .vscode/
├── bud/
├── home/
│   ├── modules/
│   ├── profiles/
│   ├── users/
│   └── default.nix
├── lib/
├── nixos/
│   ├── hosts/
│   ├── modules/
│   ├── profiles/
│   └── default.nix
├── overlays/
├── pkgs/
├── secrets/
│   ├── home/
│   │   ├── profiles/
│   │   ├── users/
│   ├── nixos/
│   │   └── profiles/
│   │       └── cloud/
│   ├── ssh/
│   └── default.nix
├── shell/
├── .editorconfig
├── .envrc
├── COPYING
├── default.nix
├── flake.lock
├── flake.nix
├── README.md
└── shell.nix
```

Many thanks to their template that helped me bootstrap my config across all my machines with an actually enjoyable way to manage dotfiles.

## Getting started

Add this to your flake (idk if the syntax is correct)
```nix
{
  inputs.dan-flk.url = "github:danielphan2003/flk";
  outputs = { dan-flk, ... }: digga.lib.mkFlake {
    channels.nixos.overlays = [ dan-flk.overlay ];
    nixos.hostDefaults.externalModules = [ dan-flk.nixosModules ];
    # home.externalModules = [ dan-flk.homeModules ];
  };
}
```

Some notes:
- ~~I'm currently using [nrdxp][nrdxp] agenix for now. For some unknown reasons I could not decrypt my secrets with my Pi when using the original repo.~~
  ~~This means (some) secrets created through this flake may not decrypt with an [earlier][divnix-agenix] version of age.~~
  Recent commits of my repo *magically* fix agenix secret decryption. I don't really understand what happened but it works. For now?
  See rage v0.6.0 [changelog][rage-v0.6.0-changelog] for more info.
- Pinning [paper][paper] as [nvfetcher][nvfetcher] does not generate outputHash for [snui][snui] dependency.

## Features

A lot of [packages][pkgs]:
- [spotify-spicetified][my-spotify-spicetified] (originally [nixpkgs#111946][nixpkgs-spotify-spicetified]).
  See my [spotify config][my-spotify-config] (currently using a custom [dribbblish][ddt] theme).
- awesomewm plugins including [bling][bling], [layout-machi][layout-machi], [lua-pam][lua-pam], and [awestore][awestore].
- Firefox tweaks:
  - [flying-fox][flying-fox]: my current firefox theme
  - [interak][interak]: my own (very MUCH wip) theme combining flying-fox, rainfox and pywalfox
  - [rainfox][rainfox]: mostly for the blurred search bar
  - [arkenfox-userjs][arkenfox-userjs]: hardened config
  - [pywalfox][pywalfox]: pywal for firefox.
- Browsers: Widevine-cdm, Edge Beta and Dev edition. Yes, I'm that evil ;)
- Messaging app: [caprine][caprine] (unmaintained)
- VS Code extensions: Utilizing [vs-ext][vs-ext]. See [`pkgs/default.nix`][vs-ext-example] for how to add a new `vscode-extensions` pkgsSet to your overlay.
- Wayland packages: [avizo][avizo].
- Android: my (very MUCH vip) take on [anbox][anbox]. I cannot find anything that works. Please open an issue if you know any alternatives.
- [Caddy][caddy] with plugins! See [pkgs/servers/caddy][caddy-with-plugins] for usage.
- Other...

Some modules that may work for your use case:
- `boot.persistence`: module to set your persist path and enable persistence handling. Basically a thin wrapper for mt-caret's opt-in state [config][optin-state].
- `services.candy`: (very MUCH wip) [Caddy][caddy] wrapper with nginx-like declarative web options.

Plus overrides and modules from devos's [community][devos-community] branch

## Eye candies and what not
- Pywal theming:
  - Very helpful wallpaper setting [script][wal-set]. It reloads pywalfox, sway border colors, along with seamless wallpaper switching and notify user when everything is done.
- X11:
  - AwesomeWM: formatted and based on [the-glorious-dotfiles][the-glorious-dotfiles]
- Wayland:
  - Latest packages from [`nixpkgs-wayland`][nixpkgs-wayland].
  - ~~Ibus [working][sway-startup]. Adapted from Arch Wiki's Ibus [integration][arch-wiki-ibus].~~ Seems broken, please open a PR for fixing this permanantly.
  - Helpful Waybar module [maker][waybar-module-maker]. See [waybar-modules][waybar-modules].
  - Working [vnc][repo-root-vnc] module and keymap passthrough with [wayvnc][wayvnc].
  - (very MUCH wip) [river][river] declarative config.

## TODOS
- Implement GitHub GitHub [workflows][auto-update-pkgs-workflow] to automatically update packages.
- [Unlock LUKS file systems via Tor][tor-luks-unlock].
- Pass the `nix flake check`.
- More...

# Acknowledgements
- [devos][devos] community and develop branch.
- [nrdxp][nrdxp]: author of [devos][devos].
- [colemickens][colemickens] for many Wayland packages and Nightly versions of Firefox he provides.
- [JavaCafe01 dotfiles][JavaCafe01-dotfiles] for my attempt to switch from sway to awesome.

[devos]: https://github.com/divnix/devos

[nrdxp]: https://github.com/nrdxp

[divnix-agenix]: https://github.com/divnix/devos/blob/develop/flake.nix#L23

[rage-v0.6.0-changelog]: https://github.com/str4d/rage/releases/tag/v0.6.0

[paper]: https://gitlab.com/snakedye/paper
[nvfetcher]: https://github.com/berberman/nvfetcher
[snui]: https://gitlab.com/snakedye/snui

[home-manager]: https://github.com/nix-community/home-manager/tree/d370447
[nrdxp-nixos]: https://github.com/nrdxp/nixpkgs/more-general-fsbefore
[impermanance]: https://github.com/nix-community/impermanance
[persistence-profile]: ./profiles/misc/persistence

[firefox-nightly]: https://github.com/colemickens/flake-firefox-nightly
[nixpkgs-wayland]: https://github.com/colemickens/nixpkgs-wayland

[pkgs]: pkgs

[nixpkgs-spotify-spicetified]: https://github.com/NixOS/nixpkgs/pull/111946
[my-spotify-spicetified]: pkgs/applications/audio/spotify-spicetified/default.nix
[my-spotify-config]: profiles/graphical/spotify/default.nix
[ddt]: https://github.com/JulienMaille/dribbblish-dynamic-theme

[bling]: https://github.com/Nooo37/bling
[layout-machi]: https://github.com/xinhaoyuan/layout-machi
[lua-pam]: https://github.com/RMTT/lua-pam
[awestore]: https://github.com/K4rakara/awestore

[flying-fox]: https://github.com/akshat46/FlyingFox/
[interak]: pkgs/data/misc/interak/default.nix
[rainfox]: https://github.com/1280px/rainfox
[arkenfox-userjs]: https://github.com/arkenfox/user.js
[pywalfox]: https://github.com/Frewacom/pywalfox-native

[caprine]: https://github.com/sindresorhus/caprine

[vs-ext]: https://github.com/divnix/vs-ext
[vs-ext-example]: ./pkgs/default.nix#L33

[caddy]: https://caddyserver.com
[caddy-with-plugins]: ./pkgs/servers/caddy/default.nix
[optin-state]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

[devos-community]: https://github.com/divnix/devos/tree/community

[avizo]: https://github.com/misterdanb/avizo
[anbox]: https://github.com/anbox/anbox

[wal-set]: users/profiles/sway/config/scripts/wal-set.nix
[sway-startup]: users/profiles/sway/config/startup.nix
[the-glorious-dotfiles]: https://github.com/manilarome/the-glorious-dotfiles
[arch-wiki-ibus]: https://wiki.archlinux.org/title/IBus#Integration
[waybar-module-maker]: lib/pkgs-build/mkWaybarModule.nix
[waybar-modules]: users/profiles/sway/waybar/modules
[repo-root-vnc]: ./home/modules/services/wayvnc.nix
[wayvnc]: https://github.com/any1/wayvnc
[river]: https://github.com/ifreund/river

[auto-update-pkgs-workflow]: ./.github/workflows/auto-update-pkgs.yml
[tor-luks-unlock]: https://nixos.wiki/wiki/Remote_LUKS_Unlocking

[colemickens]: https://github.com/colemickens
[JavaCafe01-dotfiles]: https://github.com/JavaCafe01/DotFiles
