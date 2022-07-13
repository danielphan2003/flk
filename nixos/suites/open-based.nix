{
  profiles,
  suites,
}: {
  imports = [suites.base];

  programs = {inherit (profiles.programs) terminal;};

  programs.editors = {inherit (profiles.programs.editors) neovim;};

  programs.shells = {inherit (profiles.programs.shells) zsh;};

  services = {inherit (profiles) swhkd;};
}
