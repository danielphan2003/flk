# Packages

Note that I'm only using a subset of these packages so your mileage may vary, though I *did* at least use them *once*.

- [awesomewm] plugins including [bling], [layout-machi], [lua-pam], and [awestore].

- Browsers: [widevine-cdm], [Microsoft Edge Beta][msedge-beta] and [Dev][msedge-dev] edition.

- [Caddy][caddy] with plugins! See [caddy-with-plugins] for usage.

- [eww] with latest master. Enjoy lisping :).
  - Some hm services for `eww` are available at [home/modules/services/misc](./home/modules/services/misc), including an eww-mpris service that listens for any playback activity to add and remove playback controls, as well as a yuck-lang vim syntax highlighter.
  - Sway workspaces are WIP.

- Firefox themes:
  

- Firefox tweaks:
  - [arkenfox-userjs]: hardened config
  - [pywalfox]: pywal for firefox.

- Fonts:
  - [Apple fonts][apple-fonts]: NY and SF variants
  - [Segue UI][segue-ui-fonts]: useful if you are spoofing User-Agent to Windows.

- [ntfs2btrfs] and (very MUCH wip) [quibble][quibble] efi. Mostly my attempt to create the ultimate Windows VM running on btrfs.


- [PaperMC][papermc]: A Minecraft server that is stupidly fast, and yet very customizable

- [Plymouth themes][plymouth-themes] from [adi1090x].

- [spotify-spicetified][flk-spotify-spicetified] (based on [nixpkgs#111946][nixpkgs-spotify-spicetified]).
  See my [spotify config][flk-spotify-config] (currently using a custom [dribbblish][ddt] theme).

- [Tailscale][tailscale] with a useful [profile][tailscale-profile] using age-encrypted secrets.

- VS Code extensions: Utilizing [devos-ext-lib]. See [`pkgs/default.nix`][vs-ext-example] for how to add a new `vscode-extensions` pkgsSet to your overlay.

- Wayland packages: [avizo].

- Other...

[adi1090x]: https://github.com/adi1090x

[arkenfox-userjs]: https://github.com/arkenfox/user.js

[avizo]: https://github.com/misterdanb/avizo

[awesomewm]: https://awesomewm.org

[awestore]: https://github.com/K4rakara/awestore

[bling]: https://github.com/Nooo37/bling

[caddy]: https://caddyserver.com

[caddy-with-plugins]: ../overlays/caddy.nix

[ddt]: https://github.com/JulienMaille/dribbblish-dynamic-theme

[devos-ext-lib]: https://github.com/divnix/devos-ext-lib

[eww]: https://github.com/elkowar/eww

[flk-spotify-spicetified]: ../pkgs/applications/audio/spotify-spicetified/default.nix

[flk-spotify-config]: ../nixos/profiles/apps/chill/spotify/default.nix

[layout-machi]: https://github.com/xinhaoyuan/layout-machi

[lua-pam]: https://github.com/RMTT/lua-pam

[nixpkgs-spotify-spicetified]: https://github.com/NixOS/nixpkgs/pull/111946

[ntfs2btrfs]: https://github.com/maharmstone/ntfs2btrfs

[papermc]: https://papermc.io/

[plymouth-themes]: https://github.com/adi1090x/plymouth-themes

[pywalfox]: https://github.com/Frewacom/pywalfox-native

[quibble]: https://github.com/maharmstone/quibble

[tailscale]: https://tailscale.net

[tailscale-profile]: ../nixos/profiles/network/vpn/tailscale/default.nix

[vs-ext-example]: ../pkgs/default.nix#L212-L215

## Deprecated packages

...or just packages that I don't care anymore.

These packages will be moved to another folder for easier removal in the future.

| Package name | Reason of deprecation |
|--------------|-----------------------|
| [caprine] | Inactive development (Local) |
| [flying-fox] | Inactive development |
| [interak] | i'm lazi |
| [minecraft-mods] | Superseded by [polymc] integrated mod manager |
| [paper] | Inactive development |
| [rainfox] | Inactive development |

- [caprine]: Elegant Facebook Messenger desktop app.

- [flying-fox]: An opinionated set of configurations for firefox. 

- [interak]: my own theme combining flying-fox, rainfox and pywalfox.

- [minecraft-mods]: multiple mods for both server and client, as well as choices for server.
  - Servers:
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

- [paper]: a wallpaper switcher for Wayland.

- [rainfox]: mostly for the blurred search bar.

[better-beds]: https://github.com/TeamMidnightDust/BetterBeds

[caprine]: https://github.com/sindresorhus/caprine

[cull-leaves]: https://github.com/TeamMidnightDust/CullLeaves

[fabric-api]: https://github.com/FabricMC/fabric

[fast-furnace]: https://github.com/Tfarcenim/FabricFastFurnace

[ferrite-core]: https://github.com/malte0811/FerriteCore

[flying-fox]: https://github.com/akshat46/FlyingFox

[interak]: ../pkgs/data/misc/interak/default.nix

[krypton]: https://github.com/astei/krypton

[lazydfu]: https://github.com/astei/lazydfu

[lithium]: https://github.com/CaffeineMC/lithium-fabric

[minecraft-mods]: ../pkgs/default.nix#L103

[optifine]: https://www.optifine.net/

[paper]: https://gitlab.com/snakedye/paper

[rainfox]: https://github.com/1280px/rainfox

[sodium]: https://github.com/CaffeineMC/sodium-fabric

[tuinity]: https://github.com/Tuinity/Tuinity

[starlight]: https://github.com/PaperMC/Starlight
