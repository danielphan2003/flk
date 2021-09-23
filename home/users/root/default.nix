{ self, config, ... }:
let user = "root"; in
{
  # recommend using `hashedPassword`
  age.secrets.root.file = "${self}/secrets/home/users/${user}.age";
  users.users.root = {
    passwordFile = config.age.secrets."${user}".path;
    # pwease trust me root-senpai~~
    openssh.authorizedKeys.keyFiles = [ "${self}/secrets/ssh/danie.pub" ];
  };
}
