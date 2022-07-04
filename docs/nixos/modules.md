# NixOS modules

Some modules that may work for your use case:

- `boot.persistence`: set your persist path and enable persistence handling. Basically a thin wrapper around mt-caret's opt-in state [config][optin-state].

- `services.duckdns`: update DDNS record with DuckDNS, with support for IPv6-only hosts. If you are behind a [CG-NAT][cg-nat] then this is the right module for you.

- `services.minecraft-server`: Minecraft server with hardened systemd rules, also supports on-demand startup.

- Other...

[cg-nat]: https://www.reddit.com/r/selfhosted/comments/9e707d/what_are_my_options_to_get_around_a_carrier_grade/

[optin-state]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
