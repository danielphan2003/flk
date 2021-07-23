{ ... }:
{
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };
}
