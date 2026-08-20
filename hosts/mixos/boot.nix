{pkgs, ...}: {
  boot.loader = {
    timeout = 0;
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      editor = false;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
