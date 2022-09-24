{
  lib,
  rustPlatform,
  fog,
}: let
  inherit (fog.swhkd) pname src version cargoLock;
in
  rustPlatform.buildRustPackage {
    inherit pname src version;

    cargoLock = cargoLock."Cargo.lock";

    preInstall = ''
      mkdir -p $out/lib/systemd/user $out/share/polkit-1/actions

      substitute ./contrib/init/systemd/hotkeys.service "$out/lib/systemd/user/swhkd.service" \
        --replace '# ExecStart=/path/to/hotkeys.sh' "ExecStart=/run/wrappers/bin/pkexec $out/bin/swhkd"

      substitute ./com.github.swhkd.pkexec.policy "$out/share/polkit-1/actions/com.github.swhkd.pkexec.policy" \
        --replace /usr/bin/swhkd "$out/bin/swhkd"
    '';
  }
