{
  lib,
  rustPlatform,
  dan-nixpkgs,
  makeWrapper,
  psmisc,
  runtimeShell,
}:
let
  inherit (dan-nixpkgs.swhkd) pname src version cargoLock;
in
rustPlatform.buildRustPackage {
  inherit pname src version;

  cargoLock = cargoLock."Cargo.lock";

  nativeBuildInputs = [makeWrapper];

  postInstall = ''
    cp ${./swhkd.service} ./swhkd.service

    cp ${./hotkeys.sh} ./hotkeys.sh
    chmod +x ./hotkeys.sh

    install -D -m0444 -t "$out/lib/systemd/user" ./swhkd.service
    install -D -m0444 -t "$out/share/swhkd" ./hotkeys.sh
    install -D -m0444 -t "$out/share/polkit-1/actions" ./com.github.swhkd.pkexec.policy

    chmod +x "$out/share/swhkd/hotkeys.sh"

    substituteInPlace "$out/share/swhkd/hotkeys.sh" \
      --replace @runtimeShell@ "${runtimeShell}" \
      --replace @psmisc@ "${psmisc}" \
      --replace @out@ "$out"

    substituteInPlace "$out/lib/systemd/user/swhkd.service" \
      --replace @out@ "$out/share/swhkd/hotkeys.sh"

    substituteInPlace "$out/share/polkit-1/actions/com.github.swhkd.pkexec.policy" \
      --replace /usr/bin/swhkd \
        "$out/bin/swhkd"
  '';
}
