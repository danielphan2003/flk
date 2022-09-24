{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "playit-agent";
  version = "18e692e513437c792c4b56977b72db33342a22c4";
  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = pname;
    rev = version;
    sha256 = "sha256-/7zWL3LNoT99T9o9Ozr07zoFnpjnnXBWJseUUmAx3zw=";
  };
  doCheck = false;
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "webbrowser-0.5.5" = "sha256-9LhheWDmQKUdKLsYo5Uo+Z3PlKeMMnZvfWyXOMvEf7M=";
    };
  };
}
