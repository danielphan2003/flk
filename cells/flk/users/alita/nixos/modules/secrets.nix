{config, ...}: {
  age.secrets.alita.file = "${self}/secrets/home/users/alita.age";
  users.users.alita.passwordFile = config.age.secrets.alita.path;
}
