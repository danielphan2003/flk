{self, ...}: {
  # trust yourself. who wouldn't trust themselves?
  users.users.danie.openssh.authorizedKeys.keyFiles = ["${self}/secrets/ssh/danie.pub"];

  # pwease trust me root-senpai~~
  users.users.root.openssh.authorizedKeys.keyFiles = ["${self}/secrets/ssh/danie.pub"];
}
