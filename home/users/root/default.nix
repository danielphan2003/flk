{ self, config, ... }:
let user = "root"; in
{
  # recommend using `hashedPassword`
  age.secrets.root.file = "${self}/secrets/home/users/${user}.age";
  users.users.root.passwordFile = config.age.secrets."${user}".path;
}
