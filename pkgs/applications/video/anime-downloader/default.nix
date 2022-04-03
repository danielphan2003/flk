{
  lib,
  sources,
  python3Packages,
  aria2,
  mpv,
  nodejs,
}:
with python3Packages;
  buildPythonApplication rec {
    inherit (sources.anime-downloader) pname src version;

    propagatedBuildInputs = [
      aria2
      beautifulsoup4
      cfscrape
      click
      coloredlogs
      fuzzywuzzy
      jsbeautifier
      mpv
      nodejs
      pySmartDL
      pycryptodome
      pyqt5
      requests
      requests-cache
      selenium
      tabulate
    ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/anime-dl/anime-downloader";
      description = "A simple but powerful anime downloader and streamer.";
      license = licenses.unlicense;
      platforms = ["x86_64-linux"];
      maintainers = [maintainers.danielphan2003];
    };
  }
