{ buildGoModule, lib, sources }:
buildGoModule {
  inherit (sources.wgcf) pname src version;

  subPackages = [ "." ];

  vendorSha256 = "sha256-l1hM+/585tbMvJppzB0zTtc0SQiZTSTxGkX+Os6xzso=";

  ldFlags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/ViRb3/wgcf";
    description = "🚤 Cross-platform, unofficial CLI for Cloudflare Warp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.danielphan2003 ];
  };
}
