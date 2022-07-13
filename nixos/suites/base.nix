{profiles}: {
  fonts = {inherit (profiles.fonts) minimal;};

  programs = {inherit (profiles.programs) base nix;};

  programs.shells = {inherit (profiles.programs.shells) bash;};

  security = {inherit (profiles.security) hardened;};

  services = {inherit (profiles.services) ssh;};

  users = {inherit (profiles.users) root;};
}
