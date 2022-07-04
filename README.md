# flk

flk ─ which is cold and spike-y ─ is a perfect place to build your dotfiles from the ground up!

This is where I maintain my one and only dotfiles for NixOS. It inherits pretty much the same logic as digga's [devos], with some clean up to keep the diffs clean.

## Getting started (wip)

`flk` has some useful [packages] that you can use.

```nix
{
  inputs.dan-flk.url = "github:danielphan2003/flk";
  outputs = { dan-flk, ... }: {
    nixosConfigurations."<your-machine>".
    channels.nixos.overlays = [ dan-flk.overlay ];
    nixos.hostDefaults.externalModules = [ dan-flk.nixosModules ];
    # home.externalModules = [ dan-flk.homeModules ];
  };
}
```

## Features

- [NixOS modules][nixos-modules]
- [Overlays][overlays]
- [Packages][packages]

Plus (some) overrides and modules from devos's old [community][devos-community] branch

## Notable eye candies

See [eye candies][eye-candies]

## Choices to make

See [architecture decisions][architecture-decisions]

## To dos

See [todos]

# Acknowledgements

- [devos]: old community and develop branch.
- [nrdxp]: author of [devos].
- [colemickens] for many Wayland packages and Nightly versions of Firefox he provides.
- [JavaCafe01 dotfiles][javacafe01-dotfiles] for my attempt to switch from sway to awesome.

[architecture-decisions]: ./docs/architecture-decisions

[colemickens]: https://github.com/colemickens

[devos]: https://github.com/divnix/digga/blob/main/examples/devos/flake.nix

[eye-candies]: ./docs/eye-candies.md

[javacafe01-dotfiles]: https://github.com/JavaCafe01/dotfiles

[nrdxp]: https://github.com/nrdxp

[nixos-modules]: ./docs/nixos/modules.md

[overlays]: ./docs/overlays.md

[packages]: ./docs/packages.md

[todos]: ./docs/todos.md
