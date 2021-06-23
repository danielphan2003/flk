{ lib, python3Packages }:
let inherit (python3Packages) buildPythonPackage fetchPypi wrapPython; in
buildPythonPackage rec {
  pname = "pywalfox";
  version = "2.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Uf8wmTCJt4tBRCLFfTpJ4azjqFGqKxuhu2w/r71lfb4=";
  };

  # nativeBuildInputs = [ wrapPython ];

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
    maintainers = with maintainers; [ danielphan2003 ];
  };
}