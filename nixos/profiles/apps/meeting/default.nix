{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ droidcam ]
    ++
    (if system == "x86_64-linux"
    then
      [
        # I wish I could delete zoom
        zoom-us
      ]
    else
      [
        jitsi-meet
      ]);
}
