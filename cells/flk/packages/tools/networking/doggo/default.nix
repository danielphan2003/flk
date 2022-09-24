{
  lib,
  fog,
  buildGoModule,
}:
buildGoModule rec {
  inherit (fog.doggo) pname src version;

  vendorSha256 = "sha256-qcR3fEkrd49e/p5UBklMK4dVE8Mu3uwlNJmQa0PT1jk=";

  ldflags = ["-X main.buildVersion=${version}"];

  meta = with lib; {
    description = "🐶 Command-line DNS Client for Humans. Written in Golang ";
    homepage = "https://doggo.mrkaran.dev";
    license = licenses.gpl3;
    maintainers = [maintainers.danielphan2003];
  };
}
