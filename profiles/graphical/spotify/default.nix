{ pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 57621 ];

  environment.systemPackages = with pkgs; [
    (spotify-spicetified.override {
      # spotify-unwrapped = pkgs.spotify-unwrapped-beta;
      theme = "Dribbblish";
      colorScheme = "beach-sunset";
      # injectCss = false;
      # replaceColors = false;
      # overwriteAssets = false;
      # theme = "";
      legacySupport = true;
      enabledCustomApps = [
        # "lyrics-plus"
        # "new-releases"
        "reddit"
      ];
      enabledExtensions = [
        "bookmark.js"
        "fullAppDisplay.js"
        "loopyLoop.js"
        "newRelease.js"
        "queueAll.js"
        "shuffle+.js"
        "trashbin.js"
      ];
      spotifyLaunchFlags = [
        "--enable-developer-mode"
      ];
      # customExtensions = {
      #   "autoVolume.js" = "${av}/autoVolume.js";
      # };
    })
  ];
}
