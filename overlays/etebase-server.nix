channels: final: prev: {
  # python3Packages = prev.python3Packages // {
  #   etebase-server = channels.nixpkgs.etebase-server.overrideAttrs (o: {
  #     propagatedBuildInputs = o.propagatedBuildInputs ++ [
  #       final.python3Packages.psycopg2
  #       final.python3Packages.setuptools
  #     ];
  #   });
  # };
  python3 = let
    packageOverrides = pFinal: pPrev: {
      etebase-server = pPrev.etebase-server.overridePythonAttrs (o: {
        propagatedBuildInputs =
          o.propagatedBuildInputs
          ++ [
            pFinal.psycopg2
            pFinal.setuptools
          ];
      });
    };
  in
    prev.python3.override {inherit packageOverrides;};
}
