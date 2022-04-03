{pkgs, ...}: {
  environment.systemPackages =
    builtins.attrValues
    {
      inherit
        (pkgs)
        youtube-dl
        ;
    }
    ++ (
      if pkgs.system == "x86_64-linux"
      then with pkgs; [leonflix]
      else []
    );
}
