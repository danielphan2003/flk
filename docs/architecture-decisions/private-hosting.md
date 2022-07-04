# Private hosting

Date: 2022-07-04

## Status

Partially completed.

## Context

How to self host my own services to friends and family?

## Decision

My server only has public IPv6 address, so it makes senses to use [Tailscale][tailscale] to share it with my friends.

After all, I'm already using it for self hosting private web services e.g Vaultwarden's `/admin` endpoint, Grafana etc.

## Consequences

Easier to manage, though I *have* to be the person to generate the invite link, and Tailscale limits sharing to 10 links per one device.

[tailscale]: https://tailscale.net
