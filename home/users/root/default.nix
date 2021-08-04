{ self, ... }:
# recommend using `hashedPassword`
{
  age.secrets.root.file = "${self}/secrets/home/users/root.age";
  users.users.root.passwordFile = "/run/secrets/root";
}
