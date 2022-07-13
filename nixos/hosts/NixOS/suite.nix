{
  profiles,
  suites,
}: {
  imports = [suites.networking suites.open-based];

  users = {inherit (profiles.users) nixos;};
}
