# To dos

- [x] Caddy reverse proxy with Tailscale! See [tailscale/tailscale#1235][tailscale-reverse-proxy] for updates.
      Currently services is only accessible via subpaths (i.e. `/vault`, `/grafana` etc.), but that's good enough.

- [x] Automatically update packages via [dan-nixpkgs][dan-nixpkgs].

- [ ] [Unlock LUKS file systems via Tor][tor-luks-unlock].
  - [ ] Preferably via Tailscale would be even nicer.

- [ ] (delayed indefinitely) Fully pass `nix -Lv flake check`.
  - [x] Partially pass by setting up blacklists for `nixosConfigurations.profilesTests`.
  - [ ] Properly test each machines.

- More...

[dan-nixpkgs]: https://github.com/danielphan2003/nixpkgs

[tailscale-reverse-proxy]: https://github.com/tailscale/tailscale/issues/1235

[tor-luks-unlock]: https://nixos.wiki/wiki/Remote_LUKS_Unlocking
