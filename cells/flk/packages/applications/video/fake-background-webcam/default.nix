{
  lib,
  fog,
  python3Packages,
  opencv,
}:
with python3Packages;
  buildPythonApplication rec {
    inherit (fog.fake-background-webcam) pname src version;

    propagatedBuildInputs = [
      cmapy
      configargparse
      inotify-simple
      mediapipe
      numpy
      opencv
      pyfakewebcam
    ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/fangfufu/Linux-Fake-Background-Webcam";
      description = "Faking your webcam background under GNU/Linux, now supports background blurring, animated background, colour map effect, hologram effect and on-demand processing.";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = [maintainers.danielphan2003];
    };
  }
