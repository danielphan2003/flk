{ self, lib, pkgs, profiles, ... }: {
  imports = with profiles.shell; [ aliases ];

  environment.shellInit = ''
    export STARSHIP_CONFIG=${
      pkgs.writeText "starship.toml"
      (lib.fileContents ./starship.toml)
    }
  '';

  programs.bash = {
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  fonts = lib.mkDefault {
    fonts = builtins.attrValues {
      inherit (pkgs)
        powerline-fonts
        dejavu_fonts
        ;
    };
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };
}