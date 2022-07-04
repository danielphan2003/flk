{
  lib,
  dan-nixpkgs,
  buildGoModule,
}:
buildGoModule rec {
  inherit (dan-nixpkgs.doggo) pname src version;

  vendorSha256 = "sha256-RiRWU4KyAI+PDRILkj5ILsgF0dn8MdnkNV+ui9sdops=";

  ldflags = ["-X main.buildVersion=${version}"];

  meta = with lib; {
    description = "🐶 Command-line DNS Client for Humans. Written in Golang ";
    homepage = "https://doggo.mrkaran.dev";
    license = licenses.gpl3;
    maintainers = [maintainers.danielphan2003];
  };
}
