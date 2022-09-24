{pkgs, ...}: {
  services.caddy.package = pkgs.caddy.override {
    plugins = [
      "github.com/jyooru/caddy-dns-cloudflare"
      "github.com/mholt/caddy-dynamicdns"
    ];
  };
}
