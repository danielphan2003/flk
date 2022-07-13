# To dos

- [x] Caddy reverse proxy with Tailscale! See [tailscale/tailscale#1235][tailscale-reverse-proxy] for updates.
      Currently services is only accessible via subpaths (i.e. `/vault`, `/grafana` etc.), but that's good enough.

- [x] Automatically update packages via [dan-nixpkgs][dan-nixpkgs].

- [ ] [Unlock LUKS file systems via Tor][tor-luks-unlock].

  - [ ] Preferably via Tailscale would be even nicer.

- [ ] (delayed indefinitely) Fully pass `nix -Lv flake check`.

  - [x] Partially pass by setting up blacklists for `nixosConfigurations.profilesTests`.
  - [ ] Properly test each machines.

- [ ] Intensive documentations

  - [ ] Self hostings
    - [ ] [aria2](../nixos/profiles/cloud/aria2/default.nix)
    - [ ] [caddy](../nixos/profiles/cloud/caddy/default.nix)
    - [ ] [calibre-server](../nixos/profiles/cloud/calibre-server/default.nix)
    - [ ] [calibre-web](../nixos/profiles/cloud/calibre-web/default.nix)
    - [ ] [cinny](../nixos/profiles/cloud/cinny/default.nix)
    - [ ] [etesync](../nixos/profiles/cloud/etesync/default.nix)
    - [ ] [grafana](../nixos/profiles/cloud/grafana/default.nix)
    - [ ] [jitsi](../nixos/profiles/cloud/jitsi/default.nix)
    - [ ] [matrix](../nixos/profiles/cloud/matrix/default.nix)
    - [ ] [matrix-conduit](../nixos/profiles/cloud/matrix-conduit/default.nix)
    - [ ] [matrix-identity](../nixos/profiles/cloud/matrix-identity/default.nix)
    - [ ] [minecraft](../nixos/profiles/cloud/minecraft/default.nix)
    - [ ] [netdata](../nixos/profiles/cloud/netdata/default.nix)
    - [ ] [peerix](../nixos/profiles/cloud/peerix/default.nix)
    - [ ] [postgresql](../nixos/profiles/cloud/postgresql/default.nix)
    - [ ] [rss-bridge](../nixos/profiles/cloud/rss-bridge/default.nix)
    - [ ] [spotifyd](../nixos/profiles/cloud/spotifyd/default.nix)
    - [ ] [vaultwarden](../nixos/profiles/cloud/vaultwarden/default.nix)
    - [ ] [wkd](../nixos/profiles/cloud/wkd/default.nix)

- More...

[dan-nixpkgs]: https://github.com/danielphan2003/nixpkgs
[tailscale-reverse-proxy]: https://github.com/tailscale/tailscale/issues/1235
[tor-luks-unlock]: https://nixos.wiki/wiki/Remote_LUKS_Unlocking
