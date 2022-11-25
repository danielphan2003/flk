{
  self,
  config,
  ...
}: {
  age.secrets.root.file = "${self}/secrets/home/users/root.age";
  users.users.root.passwordFile = config.age.secrets.root.path;
}
