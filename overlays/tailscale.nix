channels: final: prev:
let
  inherit (channels.go117) go_1_17;
  buildGo117Module = channels.latest.buildGoModule.override {
    go = go_1_17;
  };
in
{
  waitTailscale = prev.writeShellScriptBin "waitTailscale" ''
    # check if tailscale is already running
    status=""

    until [ $status = "Running" ]
    do
      sleep 1
      status="$(tailscale status -json | jq -r .BackendState)"
    done
  '';

  restartResolved = prev.writeShellScript "restartResolved.sh" ''
    waitTailscale
    systemctl restart systemd-resolved.service
  '';

  tailscale = channels.latest.tailscale.override {
    buildGoModule = args: buildGo117Module (args // {
      inherit (final.sources.tailscale) pname src version;
      vendorSha256 = "sha256-DcGP4yUh1OpFlzVI3YKl7cTImx8ZmTRyDYBcyLzCO/E=";
    });
    lib = with prev; lib // {
      # see https://github.com/NixOS/nixpkgs/pull/124429
      makeBinPath = args: lib.makeBinPath (args ++ [ sysctl ]);
    };
  };
}
