channels: final: prev: {
  python3Packages =
    prev.python3Packages
    // (with prev.python3Packages; {
      inherit (prev.python3Packages) pyfakewebcam;

      opencv-python = opencv4.overrideAttrs (_: {pname = "opencv-python";});

      cfscrape = cfscrape.overrideAttrs (_: {
        buildInputs = [requests responses urllib3];
      });

      cmapy = cmapy.overrideAttrs (_: {
        buildInputs = [
          matplotlib
          numpy
          final.python3Packages.opencv-python
        ];
      });

      mediapipe = mediapipe.overrideAttrs (_: {
        # format = "wheel";
        # dontBuild = true;
        # dontUnpack = true;

        # nativeBuildInputs = [ setuptools-scm ];
        propagatedBuildInputs = [
          absl-py
          attrs
          matplotlib
          numpy
          opencv4
          protobuf
          six
          wheel
        ];

        nativeBuildInputs = [wheel];

        preConfigure = ''
          unset SOURCE_DATE_EPOCH
          # Make sure that dist and the wheel file are writable.
          chmod u+rwx -R ./dist
          pushd dist
          wheel unpack --dest unpacked ./*.whl
          wheel pack ./unpacked/tensorflow*
          popd
        '';

        pythonImportsCheck = ["mediapipe"];
      });

      pillow-simd = pillow-simd.overrideAttrs (o: {
        disabledTests = o.disabledTests ++ ["test_file_libtiff"];
      });
    });
}
