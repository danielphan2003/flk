{
  self,
  lib,
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.programs.shells.env];

  environment.shellInit = ''
    export STARSHIP_CONFIG=${./starship.toml}
  '';

  programs.bash = {
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}
