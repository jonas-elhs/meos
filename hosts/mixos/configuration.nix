{
  pkgs,
  config,
  ...
}: {
  networking.hostName = config.preferences.hostname;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.${config.preferences.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "input"];
    initialPassword = config.preferences.username;
  };

  qt.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [];
  };

  hyprland.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

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
      user = config.preferences.username;
      command = "start-hyprland";
    };
  };

  nixpkgs.config.allowUnfree = true;

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
    home-manager

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

  system.stateVersion = "24.11";
}
