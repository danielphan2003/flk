{ ... }: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
    oci-containers.backend = "podman";
  };
}
