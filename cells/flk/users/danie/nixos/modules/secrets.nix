{self, config, ...}: {
  age.secrets.danie.file = "${self}/secrets/home/users/danie.age";
  users.users.danie.passwordFile = config.age.secrets.danie.path;
}
