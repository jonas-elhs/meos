{pkgs, ...}: {
  boot.loader = {
    timeout = 10;
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      editor = false;
      sortKey = "z_nixos";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
