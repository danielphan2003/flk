{pkgs, ...}: {
  environment.systemPackages = let
    wineCompat =
      if pkgs.system == "x86_64-linux"
      then {
        inherit
          (pkgs)
          bottles
          lutris
          winetricks
          ;
        inherit
          (pkgs.wineWowPackages)
          staging
          ;
      }
      else {};
  in
    builtins.attrValues wineCompat;
}
