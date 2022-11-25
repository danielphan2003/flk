{pkgs, ...}: {
  environment.systemPackages = let
    watchingCompat =
      if pkgs.system == "x86_64-linux"
      then {inherit (pkgs) leonflix;}
      else {};

    watchingPkgs = {};
  in
    builtins.attrValues (watchingCompat // watchingPkgs);
}
