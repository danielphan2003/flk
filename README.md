# My uwu dotfiles - flaky flake flk

## File structure

Quite different from normal [devos] structure:

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

## Features

A lot of [packages][pkgs]:
- [spotify-spicetified][my-spotify-spicetified] (based on [nixpkgs#111946][nixpkgs-spotify-spicetified]).
  See my [spotify config][my-spotify-config] (currently using a custom [dribbblish][ddt] theme).
- awesomewm plugins including [bling], [layout-machi], [lua-pam], and [awestore].
- Firefox tweaks:
  - [flying-fox]: my current firefox theme
  - [interak]: my own (very MUCH wip) theme combining flying-fox, rainfox and pywalfox
  - [rainfox]: mostly for the blurred search bar
  - [arkenfox-userjs]: hardened config
  - [pywalfox]: pywal for firefox.
- Browsers: Widevine-cdm, Edge Beta and Dev edition. Yes, I'm that evil ;). Surprisingly, it works on the latest rev!
- Messaging app: [caprine] (unmaintained)
- VS Code extensions: Utilizing [vs-ext]. See [`pkgs/default.nix`][vs-ext-example] for how to add a new `vscode-extensions` pkgsSet to your overlay.
- Wayland packages: [avizo].
- Android: my (very MUCH vip) take on [anbox]. I cannot find anything that works. Please open an issue if you know any alternatives.
- [Caddy][caddy] with plugins! See [pkgs/servers/caddy][caddy-with-plugins] for usage. With the latest nixpkgs, you can even define virtual hosts!
- [eww] with latest master. Enjoy lisping :).
  - Some other hm services for `eww` are available at [home/modules/services/misc](./home/modules/services/misc), including a service for dynamically add music control to each app and remove them when closed, as well as a yuck-lang syntax highlighter in vim.
- QoL font (Segue UI). This unbreaks websites and avoid rendering text with ugly serif fonts.
- [Plymouth themes][plymouth-themes] from [adi1090x].
- [ntfs2btrfs] tool and (very MUCH wip) [quibble][quibble] efi. Mostly my attempt to create the ultimate Windows VM running on btrfs.
- [Paper][paper] wallpaper switcher for Wayland.
- Fonts:
  - Apple fonts: including NY and SF variants.
  - Segue UI: this is a huge plus. Apparently a lot of websites uses this font whenever possible, and revert back to whatever font your system is using, or may not be installed yet. Therefore, it is best for this font to be installed by default.
- [MultiMC(-cracked)][mmc-cracked]: I feel ashamed of myself for using this, but I'm broke so it doesn't matter /s.
- Minecraft related packages: multiple mods for both server and client, as well as choices for server.
  - Servers:
    - [PaperMC][papermc]: stupidly fast, and yet very customizable.
    - [Tuinity][tuinity]: PaperMC fork with various patches, *including* [Starlight][starlight].
  - For both:
    - [Fabric API][fabric-api]: Fabric APIs for mods like Better Bed
    - [FerriteCore][ferrite-core]: lower RAM usage.
    - [LazyDFU][lazydfu]: something to do with MC's DFU. tl;dr it makes MC fast.
    - [Starlight][starlight]: unbelivably fast light engine. Note that this doesn't help much on client-side. Definitely recommend reading their technical paper. It widen my eyes.
  - For clients:
    - [BetterBeds][better-beds]: remove BlockEntityRenderer from the bed and replaces it with the default minecraft model renderer. (*requires* Fabric API)
    - [CullLeaves][cull-leaves]: make leaves looks just plain better. Also makes MC fast.
    - [Sodium][sodium]: improve frame rates and reduce micro-stutter. IMO this is much simpler than [OptiFine][optifine], while providing crucial performance options that matter.
  - For servers:
    - [FastFurnace][fast-furnace]: make optimizations to vanilla furnace.
    - [Krypton][krypton]: improves MC networking stack and entity tracker.
    - [Lithium][lithium]: improves a number of systems in MC without changing any behaviour.
- [Tailscale][tailscale] with a useful [profile][tailscale-profile] using age-encrypted secrets.
- Other...

Some modules that may work for your use case:
- `boot.persistence`: set your persist path and enable persistence handling. Basically a thin wrapper around mt-caret's opt-in state [config][optin-state].
- `services.duckdns`: update DDNS record with DuckDNS, with support for IPv6-only hosts. If you are behind a [CG-NAT][cg-nat] then this is the right module for you.
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
  - Ibus, ibus-bamboo, and ibus-uniemoji latest [working][sway-startup] flawlessly. Adapted from Arch Wiki's Ibus [integration][arch-wiki-ibus]. Note that shortcut for switching inputs only works on X11 apps, but you can still type normally on Wayland. An [eww] bar might fix this.
  - Helpful Waybar module [maker][waybar-module-maker]. See [waybar-modules][waybar-modules].
  - Working [vnc][repo-root-vnc] module and keymap passthrough with [wayvnc].
  - (very MUCH wip) [river] declarative config.

## Reasoning (new)

For Minecraft mods, I went ahead and refer to [Performance Mods][performance-mods] from [alkyaly]. As a result, my choices of mods for server-side and client-side are solely based on the performance improvement column within it.
- One of my friends has a crappy Chromebook that could benefit from any optimization mods, and by using FerriteCore, LazyDFU, CullLeaves, and Sodium, he was able to achieve *unknown* FPS (Chromebook doesn't even have F3 button, and mods showing FPS requires Fabric API).
  His impression was very much positive as he found out it was much more responsive than before. Definitely a must-have for clients running on old hardware.
- Paper didn't allow me to install Fabric Loader, so it was kind of a miss, but [Starlight][starlight] came around and I really wanted to try it out. Luckily, there is a Paper fork called [Tuinity][tuinity], and it includes a lot of performance patches, *including* a patch that uses Starlight.
- I would very much stay far away from Fabric API, as my friend's FPS dropped significantly when having that mod, and after I accidently recommended him to install it.
- Starlight should be a must-have on servers considering how impactful it is on server resources. Remember, I run Tuinity on a 2 GB Raspberry Pi 4, and its RAM usage never goes over 90% even with multiplayer.
- My server only has public IPv6 address, so it makes senses to use [Tailscale][tailscale] to share it with my friends. Besides, you get all the amazing things [WireGuard][wireguard] has to offer, as well as hostname addresses that just resolves to that host's IP, so I can do fancy things like adding a server with address "pik2" and MC would resolve it to the proper address.

## TODOS
- [ ] Caddy reverse proxy with Tailscale! See [tailscale/tailscale#1235][tailscale-reverse-proxy] for updates.
  I really look forward to this, it just makes me want to abandon DuckDNS altogether and host everything locally.
  I hope to access them via custom TLDs and have HTTPS as the same time.
- [ ] Automatically update packages via [workflows][auto-update-pkgs-workflow].
  - [ ] (delayed indefinitely) Enable testing.
  - [ ] Commit message could be smaller, but it requires:
    - uploading `pkgs/_sources/.shake*` (more conflicts)
    - or making [nvfetcher] aware of already-up-to-date packages in generated [sources][generated-sources] (increased update time).
- [ ] [Unlock LUKS file systems via Tor][tor-luks-unlock].
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
[tailscale-profile]: ./nixos/profiles/network/tailscale/default.nix

[optin-state]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html

[cg-nat]: https://www.reddit.com/r/selfhosted/comments/9e707d/what_are_my_options_to_get_around_a_carrier_grade/

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

[performance-mods]: https://gist.github.com/alkyaly/02830c560d15256855bc529e1e232e88
[alkyaly]: https://github.com/alkyaly

[wireguard]: https://www.wireguard.com

[tailscale-reverse-proxy]: https://github.com/tailscale/tailscale/issues/1235
[auto-update-pkgs-workflow]: ./.github/workflows/auto-update-pkgs.yml
[generated-sources]: pkgs/_sources/generated.nix
[tor-luks-unlock]: https://nixos.wiki/wiki/Remote_LUKS_Unlocking

[colemickens]: https://github.com/colemickens
[JavaCafe01-dotfiles]: https://github.com/JavaCafe01/DotFiles
