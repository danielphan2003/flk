{pkgs, ...}: {
  programs.droidcam.enable = true;

  environment.systemPackages = let
    meetingCompat =
      if pkgs.system == "x86_64-linux"
      # I wish I could delete zoom
      then {inherit (pkgs) teams zoom-us;}
      else {};

    meetingPkgs = {
      inherit
        (pkgs)
        jitsi-meet
        ;
    };
  in
    builtins.attrValues (meetingCompat // meetingPkgs);
}
