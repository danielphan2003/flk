{ python3, lib, sources }:
python3.pkgs.buildPythonApplication rec {
  inherit (sources.pywalfox) pname src version;

  preInstall = ''
    substituteInPlace pywalfox/install.py --replace "/usr" "$out"
    substituteInPlace pywalfox/bin/main.sh --replace "/usr/local" "$out"

    substituteInPlace pywalfox/assets/manifest.json \
      --replace "<path>" "$out/bin/pywalfox-daemon.sh"

    mkdir -p $out/lib/mozilla/native-messaging-hosts
    cp pywalfox/assets/manifest.json $out/lib/mozilla/native-messaging-hosts/pywalfox.json

    mkdir -p $out/chrome
    cp pywalfox/assets/css/* $out/chrome

    mkdir -p $out/bin
    cp pywalfox/bin/main.sh $out/bin/pywalfox-daemon.sh
  '';

  preFixup = ''
    wrapProgram $out/bin/pywalfox-daemon.sh --prefix PYTHONPATH : $PYTHONPATH 
  '';

  meta = with lib; {
    description = "Native app used alongside the Pywalfox browser extension";
    homepage = "https://github.com/frewacom/pywalfox-native";
    license = licenses.mpl20;
    maintainers = [ danielphan2003 ];
  };
}