{
  config,
  lib,
  pkgs,
  ...
}: {
  qt.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [];
  };

  hyprland.enable = true;
  bluetooth.enable = true;
  hardware-acceleration.enable = true;
  pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
  home-manager.enable = true;
  config-root = "/home/jonas/nixos";

  boot-loader = {
    systemd-boot.enable = true;
    timeout = 10;
    extraConfig = ''
      auto-entries no
    '';
    extraEntries = [
      {
        name = "windows11";
        title = "Windows 11";
        efi = "/EFI/Microsoft/boot/bootmgfw.efi";
        sortKey = "a_windows";
      }
    ];
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  display-manager = {
    autologin = {
      enable = true;
      user = "jonas";
      command = "start-hyprland";
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  services.keyd = {
    enable = true;

    keyboards.default = {
      settings = {
        main = {
          shift = "oneshot(shift)";
          meta = "oneshot(meta)";
          control = "oneshot(control)";
          leftalt = "oneshot(alt)";
          rightalt = "oneshot(altgr)";

          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };

  # TEMPORARY --- will move to nixos-modules
  # networking.wireless.enable = true;
  # END TEMPORARY

  # TEMPORARY --- will move to nixos-modules
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  # END TEMPORARY

  environment.systemPackages = with pkgs; [
    # TEMPORARY --- will move to home-manager
    wl-clipboard
    cliphist

    firefox

    tree
    # END TEMPORARY

    # MAIL
    thunderbird
    mailspring # wayland problem?
    bluemail
    # END MAIL

    # FILES
    #    xfce.thunar
    kdePackages.dolphin
    #    pcmanfm
    # END FILES
  ];

  system.architecture = "x86_64-linux";
  system.stateVersion = "24.11";
}
