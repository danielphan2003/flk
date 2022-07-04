{
  buildGoModule,
  lib,
  dan-nixpkgs,
}:
buildGoModule {
  inherit (dan-nixpkgs.argonone-fancontrold) pname src version;

  vendorSha256 = "sha256-0xhHGJEPFpwjRA03C8rpuZ2sIXU50+PS6ifTRMSrHKM=";

  meta = with lib; {
    homepage = "https://github.com/mgdm/argonone-utils";
    license = licenses.bsd2;
    maintainers = [maintainers.danielphan2003];
  };
}
