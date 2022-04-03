let
  # set ssh public keys here for your system and user
  pik2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPX+ah50jmnLkmDPjSc7fN6+bLVdfPtABgncHgx9qwG5";
  themachine = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChwVJyCdn/aBvqXyTpuXfo/u75zjd+10YaCa9wLwFrVsEg28QOtVcc8sbDkfxHKCVt0pAY8EDwp5PLs1JkOss0lMAmSaVJMNIwIuhnZ0e8g7vhzo2ckdKpAPISyrC98aw5jws4yTMa6jTi+908xc0Y+d25IrI3mvIT1m3XmI8y22IEBo3hp7UQp6CfapqbCoJrErbFe9i14yJ5PaHfCV6PPKoRmGlg84CRw4S3k9RfKO/kea439cn6UvQocw7u59xemFGcbfC/WWi5mWOrt2L/VhCn87BqSCcDi5pNuByLai9VIPubN62rugwOErh3mf/lf6slHCAlPrLMiiQpHSrnS275/sGOOncG4ZbZ8dNO4j8z7dxKIsuzxBUxSIP5zPcxGEwxEDinaqoyyU1fD59G5QwDW4Od26q2xA/cct7z+REKe/lMyQnjQ99TMNaUB6/DAlaOZ7rzSrCNZYTrq07t1qvk4sH7FM9EMfKYOPvPnWbahoHYoVKTA2LPgsAXCNVZqTkHV6hgwsOVu70ueaGUHAKFVbwyutFjtL0vI0M93J2Wo1QG//DcgiDEtIn2x+LntdWAVC8l8dhEgpqlFcwyReDNJvV7sNAKPghXuUG6574WzHmYn0yyI0SMhQwdYC/V9q3zNAqptvWQv/hdlXmfmVuN49HK9cMBUwYJfWIs2Q==";
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
