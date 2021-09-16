{ lib, package, prefix, python3Packages }:
let pname = lib.removePrefix prefix package.pname; in
python3Packages.buildPythonPackage {
  inherit pname;
  inherit (package) src version;

  doCheck = false;
}
