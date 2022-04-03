{
  buildGoModule,
  lib,
  sources,
}:
buildGoModule {
  inherit (sources.argonone-fancontrold) pname src version;

  vendorSha256 = "sha256-0xhHGJEPFpwjRA03C8rpuZ2sIXU50+PS6ifTRMSrHKM=";

  meta = with lib; {
    homepage = "https://github.com/mgdm/argonone-utils";
    license = licenses.bsd2;
    maintainers = [maintainers.danielphan2003];
  };
}
