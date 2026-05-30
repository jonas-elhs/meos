{pkgs, ...}: {
  boot.loader = {
    timeout = 10;
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      editor = false;
      extraEntries = {
        "windows11.conf" = ''
          title Windows 11
          efi /EFI/Microsoft/boot/bootmgfw.efi
          sort-key a_windows
        '';
      };
      extraInstallCommands = let
        config = "auto-entries no";
      in "echo '${config}' >> /boot/loader/loader.conf";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
