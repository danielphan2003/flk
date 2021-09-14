{ lib, sources, buildGoModule }:
buildGoModule rec {
  inherit (sources.doggo) pname src version;

  vendorSha256 = "sha256-eyR1LuaMkyQqIaV4GN/7Nr1TkdHr+M3C3z/pyNF0Vo4=";

  ldflags = [ "-X main.buildVersion=${version}" ];

  meta = with lib; {
    description = "🐶 Command-line DNS Client for Humans. Written in Golang ";
    homepage = "https://doggo.mrkaran.dev";
    license = licenses.gpl3;
    maintainers = [ maintainers.danielphan2003 ];
  };
}
