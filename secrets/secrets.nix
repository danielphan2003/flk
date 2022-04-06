let
  # set ssh public keys here for your system and user
  pik2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPX+ah50jmnLkmDPjSc7fN6+bLVdfPtABgncHgx9qwG5";
  themachine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+SPYr7r+FSy/IY/TI4VYOKFkZ2X5yjsj8eYSIuvDRO";
  systems = [themachine pik2];

  alita = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENcgkaR9Eut882LrniZvXzZ26ik5JWZzyNG7odZ172d";
  danie = "age1yubikey1q293cy2t04vz0aallsfcvy5qgk3tmw7rnmz9e6syhcf3esawxfdcu6e9ghn";
  defaultUsers = [danie];
  users = defaultUsers ++ [alita];

  allKeys = systems ++ users;
in {
  "home/users/root.age".publicKeys = allKeys;
  "home/users/alita.age".publicKeys = [alita pik2] ++ [danie themachine];
  "home/users/danie.age".publicKeys = [danie themachine];

  "home/profiles/accounts.age".publicKeys = defaultUsers ++ [themachine];

  "nixos/profiles/cloud/caddy.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/calibre-server/users.sqlite.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/cloudflare.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/duckdns.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/minecraft/ops.age".publicKeys = [alita pik2] ++ [danie themachine];
  "nixos/profiles/cloud/minecraft/whitelist.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/spotify.age".publicKeys = [alita pik2] ++ [danie themachine];

  "nixos/profiles/cloud/vaultwarden.age".publicKeys = [alita pik2] ++ [danie themachine];
}
