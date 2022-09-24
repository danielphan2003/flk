{...}: {
  services.dnscrypt-proxy2.settings = {
    tls_cipher_suite = [52392 49199];
    max_clients = 10000;
  };
}
