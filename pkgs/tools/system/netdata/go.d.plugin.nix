{ lib, sources, buildGoModule }:

buildGoModule rec {
  pname = "netdata-go.d.plugin";
  inherit (sources.netdata-go-d-plugin) src version;

  vendorSha256 = "sha256-17/f6tAxDD5TgjmwnqAlnQSxDhnFidjsN55/sUMDej8=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
