# My uwu dotfiles - flaky flake flk

## File structure

Quite different from normal [devos] structure:

```
/
├── .github/
├── .vscode/
├── bud/
├── deploy/
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

Add this to your flake (not sure if the syntax is correct)
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

## Features

Helpful overlays:
- [electron-compat][electron-compat]: a compat layer that makes Electron apps run natively on X11 and Wayland.
  Apps are wrapped with a Bash script that evals to platform-specific flags. To prevent double wrapping `$out/.bin-wrapped` is used so that application name shows up correctly in htop or other programs.

A lot of [packages][pkgs]:
- Android: my (very MUCH vip) take on [anbox]. I cannot find anything that works. Please recommend if you know any alternatives.
- awesomewm plugins including [bling], [layout-machi], [lua-pam], and [awestore].
- Browsers: Widevine-cdm, Microsoft Edge Beta and Dev edition.
  Yes, I'm that evil ;).
- [Caddy][caddy] with plugins! See [pkgs/servers/caddy][caddy-with-plugins] for usage.
- [eww] with latest master. Enjoy lisping :).
  - Some hm services for `eww` are available at [home/modules/services/misc](./home/modules/services/misc), including an eww-mpris service that listens for any playback activity to add and remove playback controls, as well as a yuck-lang vim syntax highlighter.
  - Sway workspaces are functional, but should be improved later.
- Firefox tweaks:
  - [flying-fox]: my current firefox theme
  - [interak]: my own (very MUCH wip) theme combining flying-fox, rainfox and pywalfox
  - [rainfox]: mostly for the blurred search bar
  - [arkenfox-userjs]: hardened config
  - [pywalfox]: pywal for firefox.
- Fonts:
  - Apple fonts: NY and SF variants
  - Segue UI: useful if you are spoofing User-Agent to Windows.
- Messaging app: [caprine] (unmaintained)
- Minecraft related packages: multiple mods for both server and client, as well as choices for server.
  - Servers:
    - [PaperMC][papermc]: stupidly fast, and yet very customizable
    - [Tuinity][tuinity]: PaperMC fork with various patches, *including* [Starlight][starlight].
  - For both:
    - [Fabric API][fabric-api]: Fabric APIs for mods like Better Bed
    - [FerriteCore][ferrite-core]: lower RAM usage
    - [LazyDFU][lazydfu]: something to do with MC's DFU. tl;dr it makes MC fast
    - [Starlight][starlight]: unbelivably fast light engine. Note that this doesn't help much on client-side. Definitely recommend reading their technical paper. It widen my eyes.
  - For clients:
    - [BetterBeds][better-beds]: remove BlockEntityRenderer from the bed and replaces it with the default minecraft model renderer. (*requires* Fabric API)
    - [CullLeaves][cull-leaves]: make leaves looks just plain better. Also makes MC fast
    - [Sodium][sodium]: improve frame rates and reduce micro-stutter. IMO this is much simpler than [OptiFine][optifine], while providing crucial performance options that matter.
  - For servers:
    - [FastFurnace][fast-furnace]: make optimizations to vanilla furnace
    - [Krypton][krypton]: improves MC networking stack and entity tracker
    - [Lithium][lithium]: improves a number of systems in MC without changing any behaviour.
- [MultiMC(-cracked)][mmc-cracked]: I feel ashamed of myself for using this, but I'm broke so it doesn't matter /s.
- [ntfs2btrfs] and (very MUCH wip) [quibble][quibble] efi. Mostly my attempt to create the ultimate Windows VM running on btrfs.
- [Paper][paper] wallpaper switcher for Wayland.
- [Plymouth themes][plymouth-themes] from [adi1090x].
- [spotify-spicetified][my-spotify-spicetified] (based on [nixpkgs#111946][nixpkgs-spotify-spicetified]).
  See my [spotify config][my-spotify-config] (currently using a custom [dribbblish][ddt] theme).
- [Tailscale][tailscale] with a useful [profile][tailscale-profile] using age-encrypted secrets.
- VS Code extensions: Utilizing [vs-ext]. See [`pkgs/default.nix`][vs-ext-example] for how to add a new `vscode-extensions` pkgsSet to your overlay.
- Wayland packages: [avizo].
- Other...

Some modules that may work for your use case:
- `boot.persistence`: set your persist path and enable persistence handling. Basically a thin wrapper around mt-caret's opt-in state [config][optin-state].
- `services.duckdns`: update DDNS record with DuckDNS, with support for IPv6-only hosts. If you are behind a [CG-NAT][cg-nat] then this is the right module for you.
- `services.minecraft-server`: Minecraft server with hardened systemd rules, also supports on-demand startup.
- Other...

Plus (some) overrides and modules from devos's [community][devos-community] branch

## Eye candies and what not
- Pywal theming:
  - Very helpful wallpaper setting [script][wal-set]. It reloads pywalfox, sway border colors, along with seamless wallpaper switching and notify user when everything is done.
- Gnome: bare minimum for now.
- Systemd-Networkd: remove the need for NetworkManager (it sucks anyway).
- X11:
  - AwesomeWM: formatted and based on [the-glorious-dotfiles].
- Wayland:
  - Latest packages from [`nixpkgs-wayland`][nixpkgs-wayland].
  - Latest ibus, ibus-bamboo, and ibus-uniemoji [work][sway-startup] flawlessly. Adapted from Arch Wiki's Ibus [integration][arch-wiki-ibus]. Note that shortcut for switching inputs only works on X11 apps, but you can still type normally on Wayland (not with in native Electron apps though). An [eww] bar might fix this.
  - Helpful Waybar module [maker][waybar-module-maker]. See [waybar-modules][waybar-modules].
  - Working [vnc][wayvnc-hm] module (and keymap passthrough?) with [wayvnc].
  - (very MUCH wip) [river] declarative config.

## Choices to make

For Minecraft mods, I went ahead and refer to [Performance Mods][performance-mods] from [alkyaly]. As a result, my choices of mods for server-side and client-side are solely based on the performance improvement column within it.
- One of my friends has a crappy Chromebook that barely has 4GB of RAM available. He could benefit from any optimization mods, so with FerriteCore, LazyDFU, CullLeaves, and Sodium enabled he was able to achieve more than *unknown* FPS than before (Chromebook doesn't even have F3 button, and mods showing FPS requires Fabric API).
  His impression was very much positive as it was much more responsive than before. Definitely a must-have for clients running on old hardware.
- Paper didn't allow me to install Fabric Loader, so it was kind of a miss, but [Starlight][starlight] came around and I really wanted to try it out. Luckily, there is a Paper fork called [Tuinity][tuinity], and it includes a lot of performance patches, *including* a patch that uses Starlight.
- I would very much stay far away from Fabric API, as my friend's FPS dropped significantly when having that mod, and after I accidently recommended him to install it :v
- Starlight should be a must-have on servers considering how impactful it is on server resources. I run MC server on a Raspberry Pi 4 with 2GB of RAM, and total usage never goes over 90% even with multiplayer enabled (around 4-9 players).
- My server only has public IPv6 address, so it makes senses to use [Tailscale][tailscale] to share it with my friends. After all, I'm already using it for self hosting private web services e.g Vaultwarden's `/admin` endpoint, Grafana etc.

## TODOS
- [x] Caddy reverse proxy with Tailscale! See [tailscale/tailscale#1235][tailscale-reverse-proxy] for updates.
  Currently services is only accessible via subpaths (i.e. `/vault`, `/grafana` etc.), but that's good enough.
- [x] Automatically update packages via [dan-nixpkgs][dan-nixpkgs].
- [ ] [Unlock LUKS file systems via Tor][tor-luks-unlock].
  - [ ] Preferably via Tailscale would be even nicer.
- [ ] (delayed indefinitely) Fully pass `nix -Lv flake check`.
  - [x] Partially pass by setting up blacklists for `nixosConfigurations.profilesTests`.
  - [ ] Properly test each machines.
- More...

# Acknowledgements
- [devos] community and develop branch.
- [nrdxp]: author of [devos].
- [colemickens] for many Wayland packages and Nightly versions of Firefox he provides.
- [JavaCafe01 dotfiles][JavaCafe01-dotfiles] for my attempt to switch from sway to awesome.

[devos]: https://github.com/divnix/devos

[nrdxp]: https://github.com/nrdxp

[divnix-agenix]: https://github.com/divnix/devos/blob/develop/flake.nix#L23

[rage-v0.6.0-changelog]: https://github.com/str4d/rage/releases/tag/v0.6.0

[paper]: https://gitlab.com/snakedye/paper
[nvfetcher]: https://github.com/berberman/nvfetcher
[snui]: https://gitlab.com/snakedye/snui

[GTrunSec]: https://github.com/GTrunSec

[home-manager]: https://github.com/nix-community/home-manager/tree/d370447
[nrdxp-nixos]: https://github.com/nrdxp/nixpkgs/more-general-fsbefore
[impermanance]: https://github.com/nix-community/impermanance
[persistence-profile]: ./nixos/profiles/misc/persistence

[firefox-nightly]: https://github.com/colemickens/flake-firefox-nightly
[nixpkgs-wayland]: https://github.com/colemickens/nixpkgs-wayland

[electron-compat]: ./overlays/electron.nix

[pkgs]: ./pkgs

[nixpkgs-spotify-spicetified]: https://github.com/NixOS/nixpkgs/pull/111946
[my-spotify-spicetified]: ./pkgs/applications/audio/spotify-spicetified/default.nix
[my-spotify-config]: ./nixos/profiles/apps/spotify/default.nix
[ddt]: https://github.com/JulienMaille/dribbblish-dynamic-theme

[bling]: https://github.com/Nooo37/bling
[layout-machi]: https://github.com/xinhaoyuan/layout-machi
[lua-pam]: https://github.com/RMTT/lua-pam
[awestore]: https://github.com/K4rakara/awestore

[flying-fox]: https://github.com/akshat46/FlyingFox
[interak]: ./pkgs/data/misc/interak/default.nix
[rainfox]: https://github.com/1280px/rainfox
[arkenfox-userjs]: https://github.com/arkenfox/user.js
[pywalfox]: https://github.com/Frewacom/pywalfox-native

[caprine]: https://github.com/sindresorhus/caprine

[vs-ext]: https://github.com/divnix/vs-ext
[vs-ext-example]: ./pkgs/default.nix#L91

[caddy]: https://caddyserver.com
[caddy-with-plugins]: ./pkgs/servers/caddy/default.nix
[eww]: https://github.com/elkowar/eww

[plymouth-themes]: https://github.com/adi1090x/plymouth-themes
[adi1090x]: https://github.com/adi1090x

[ntfs2btrfs]: https://github.com/maharmstone/ntfs2btrfs
[quibble]: https://github.com/maharmstone/quibble

[paper]: https://gitlab.com/snakedye/paper

[mmc-cracked]: https://github.com/AfoninZ/MultiMC5-Cracked

[papermc]: https://papermc.io/
[tuinity]: https://github.com/Tuinity/Tuinity
[starlight]: https://github.com/PaperMC/Starlight
[fabric-api]: https://github.com/FabricMC/fabric
[ferrite-core]: https://github.com/malte0811/FerriteCore
[lazydfu]: https://github.com/astei/lazydfu
[better-beds]: https://github.com/TeamMidnightDust/BetterBeds
[cull-leaves]: https://github.com/TeamMidnightDust/CullLeaves
[sodium]: https://github.com/CaffeineMC/sodium-fabric
[fast-furnace]: https://github.com/Tfarcenim/FabricFastFurnace
[krypton]: https://github.com/astei/krypton
[lithium]: https://github.com/CaffeineMC/lithium-fabric

[tailscale]: https://tailscale.net
[tailscale-profile]: ./nixos/profiles/network/dns/tailscale/default.nix

[optin-state]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

[cg-nat]: https://www.reddit.com/r/selfhosted/comments/9e707d/what_are_my_options_to_get_around_a_carrier_grade/

[devos-community]: https://github.com/divnix/devos/tree/community

[avizo]: https://github.com/misterdanb/avizo
[anbox]: https://github.com/anbox/anbox

[wal-set]: ./home/profiles/sway/config/scripts/wal-set.nix
[sway-startup]: ./home/profiles/sway/config/startup.nix
[the-glorious-dotfiles]: https://github.com/manilarome/the-glorious-dotfiles
[arch-wiki-ibus]: https://wiki.archlinux.org/title/IBus#Integration
[waybar-module-maker]: ./lib/pkgs-build/mkWaybarModule.nix
[waybar-modules]: ./home/profiles/sway/waybar/modules
[wayvnc-hm]: ./home/modules/services/misc/wayvnc.nix
[wayvnc]: https://github.com/any1/wayvnc
[river]: https://github.com/ifreund/river

[performance-mods]: https://gist.github.com/alkyaly/02830c560d15256855bc529e1e232e88
[alkyaly]: https://github.com/alkyaly

[wireguard]: https://www.wireguard.com

[tailscale-reverse-proxy]: https://github.com/tailscale/tailscale/issues/1235
[dan-nixpkgs]: https://github.com/danielphan2003/nixpkgs
[tor-luks-unlock]: https://nixos.wiki/wiki/Remote_LUKS_Unlocking

[colemickens]: https://github.com/colemickens
[JavaCafe01-dotfiles]: https://github.com/JavaCafe01/DotFiles
