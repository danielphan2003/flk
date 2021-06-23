let
  inherit (builtins) readFile;

  # set ssh public keys here for your system and user
  pik2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPX+ah50jmnLkmDPjSc7fN6+bLVdfPtABgncHgx9qwG5";
  themachine = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChwVJyCdn/aBvqXyTpuXfo/u75zjd+10YaCa9wLwFrVsEg28QOtVcc8sbDkfxHKCVt0pAY8EDwp5PLs1JkOss0lMAmSaVJMNIwIuhnZ0e8g7vhzo2ckdKpAPISyrC98aw5jws4yTMa6jTi+908xc0Y+d25IrI3mvIT1m3XmI8y22IEBo3hp7UQp6CfapqbCoJrErbFe9i14yJ5PaHfCV6PPKoRmGlg84CRw4S3k9RfKO/kea439cn6UvQocw7u59xemFGcbfC/WWi5mWOrt2L/VhCn87BqSCcDi5pNuByLai9VIPubN62rugwOErh3mf/lf6slHCAlPrLMiiQpHSrnS275/sGOOncG4ZbZ8dNO4j8z7dxKIsuzxBUxSIP5zPcxGEwxEDinaqoyyU1fD59G5QwDW4Od26q2xA/cct7z+REKe/lMyQnjQ99TMNaUB6/DAlaOZ7rzSrCNZYTrq07t1qvk4sH7FM9EMfKYOPvPnWbahoHYoVKTA2LPgsAXCNVZqTkHV6hgwsOVu70ueaGUHAKFVbwyutFjtL0vI0M93J2Wo1QG//DcgiDEtIn2x+LntdWAVC8l8dhEgpqlFcwyReDNJvV7sNAKPghXuUG6574WzHmYn0yyI0SMhQwdYC/V9q3zNAqptvWQv/hdlXmfmVuN49HK9cMBUwYJfWIs2Q==";
  systems = [ themachine pik2 ];

  alita = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENcgkaR9Eut882LrniZvXzZ26ik5JWZzyNG7odZ172d";
  danie = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCknIEk6AGAjpgT78Q27BbLpeTDWmYBRZRCUUDW0y3uE2obGD/YAu/7UhjHq/fgZNyDEZ2tjjMdvgil/32LpRYYyVk9rWAWrnnn85tZacOL/LAA09f/COeqCp7QErR8mvbAWxL25ZhLoFCM3tB5BhS1BXI4vCP+XDPhkjmDmuCDkIUlbOrzz4nd/U7qLvY2m30/Hagmbt4iM3cl3t0Zsic8c/J5n/0eYFA5SOp1GaKP1SpdzFuCPYlk7aljES16J2XYQTJ/FotA0gch5oSe94Xit5rYqDl/NjYPklf3KyPOY+QwJOERSUqI+xAepXZ/9vHn0Tex71IeNk3+zOxOgBbfw386LqRnI0PFjsyX1Jznmh9J9dYPBINihg9SW/m4JCN8rxGnZLmu3vcukvV1jUhre008EcAkdwwvWTA03n9Id8pr/r1B7KX1Mn7CQ4V13ZcFbS33y3jQEHghiTI3SDlyIDjxZLoS6H0Cupja/1nrimPQdRwh036PGNBu3M+W9EEUaTBPpcldJs1GxkA1Lx1GNW/pkv6NqomxFoYRQEdv1EyAOuEGDhcXpYVZs7HA8Jh1xRObEAL7iP0mqvuJ+ztsp6Lt7JdnNUH0JkgS3m1bEM3iOpm7EElw+Xw9foAT2Vlt0bITD9Syqe8kHFa7jb7HnMGD781CfbtOrm8Ch3uZsw==";
  defaultUsers = [ danie ];
  users = defaultUsers ++ [ alita ];

  allKeys = systems ++ users;
in
{
  # "secret.age".publicKeys = allKeys;

  "root.age".publicKeys = allKeys;
  "alita.age".publicKeys = [ alita pik2 ] ++ [ danie themachine ];
  "danie.age".publicKeys = [ danie themachine ];

  "accounts.age".publicKeys = defaultUsers ++ [ themachine ];
  "bitwarden.age".publicKeys = [ alita pik2 ] ++ [ danie themachine ];
  "duckdns.age".publicKeys = [ alita pik2 ] ++ [ danie themachine ];
}
