final: prev: {
  python3Packages = prev.python3Packages // (with prev.python3Packages; {
    cfscrape = cfscrape.overrideAttrs (_: {
      buildInputs = [ requests urllib3 ];
    });
    pillow-simd = pillow-simd.overrideAttrs (o: {
      disabledTests = o.disabledTests ++ [ "test_file_libtiff" ];
    });
  });
}
