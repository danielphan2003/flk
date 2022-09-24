{
  python3,
  lib,
  fog,
}:
python3.pkgs.buildPythonApplication {
  inherit (fog.pywalfox) pname src version;

  preInstall = ''
    substituteInPlace pywalfox/install.py --replace "/usr" "$out"
    substituteInPlace pywalfox/bin/main.sh --replace "/usr/local" "$out"

    substituteInPlace pywalfox/assets/manifest.json \
      --replace "<path>" "$out/bin/pywalfox-daemon.sh"

    mkdir -p $out/lib/mozilla/native-messaging-hosts
    cp pywalfox/assets/manifest.json $out/lib/mozilla/native-messaging-hosts/pywalfox.json

    mkdir -p $out/chrome
    cp pywalfox/assets/css/* $out/chrome
  '';

  # preFixup = ''
  #   makeWrapper $out/bin/pywalfox $out/bin/pywalfox-daemon.sh \
  #     --add-flags start
  # '';

  meta = with lib; {
    description = "Native app used alongside the Pywalfox browser extension";
    homepage = "https://github.com/frewacom/pywalfox-native";
    license = licenses.mpl20;
    maintainers = [maintainers.danielphan2003];
  };
}
