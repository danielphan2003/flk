{ pkgs, ... }: {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      feh
      maim
      rofi
      xclip
      xidlehook
      xsel
      ;
  };
}
