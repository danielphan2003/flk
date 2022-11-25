{pkgs, ...}: {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      ffmpeg-full
      mpv
      yt-dlp
      ;
  };

  environment.shellAliases = {
    yt = "yt-dlp --downloader aria2c --add-metadata -i";
    yta = "yt -x -f bestaudio/best";
    ffmpeg = "ffmpeg -hide_banner";
  };
}
