{
  pkgs,
  config,
  inputs,
  wrappers,
  ...
}: {
  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  networking.hostName = config.preferences.hostname;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.${config.preferences.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "input"];
    initialPassword = config.preferences.username;
  };

  qt.enable = true;
  programs.nix-ld.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
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

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        user = config.preferences.username;
        command = "start-hyprland";
      };
      default_session = initial_session;
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

  # Fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    (callPackage ../../packages/maple-nerd-font-mono.nix {})
    (callPackage ../../packages/maple-nerd-font-propo.nix {})

    material-symbols
  ];

  programs.git = {
    enable = true;
    package = wrappers.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
          name = "jonas-elhs";
          email = "jonas.elhs@outlook.com";
        };
      };
    };
  };

  programs.fish = {
    enable = true;
    package = wrappers.wrappers.fish.wrap {
      inherit pkgs;

      plugins = with pkgs.fishPlugins; [
        autopair
      ];
      configFile.content = ''
        fish_vi_key_bindings
        set -g fish_autosuggestion_enabled 0
        set -g fish_greeting

        if not status is-login && test "$TERM" != "dumb"
          starship init fish | source
        end
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    (wrappers.wrappers.jujutsu.wrap {
      inherit pkgs;

      settings = {
        user = {
          name = "jonas-elhs";
          email = "jonas.elhs@outlook.com";
        };
      };
    })

    (wrappers.wrappers.hypridle.wrap {
      inherit pkgs;

      settings = {
        general = {
          lock_cmd = "meshell lock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          # Lock System - 5 Minutes
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }

          # Dim Screen - 20 Minutes
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

          # Suspend System - 1 hour
          {
            timeout = 3600;
            on-timeout = "systemctl hibernate";
          }
        ];
      };
    })

    # krita
    hyprpicker
    fuzzel

    rustc
    cargo
    gcc
    gnumake
    cmake

    inputs.meshell.packages.x86_64-linux.cli
    # inputs.mevim.packages.x86_64-linux.neovim

    nasm
    llvmPackages_latest.bintools-unwrapped
    lazygit
    uv
    teams-for-linux
    libnotify
    obs-studio
    davinci-resolve
    mpv
    pkg-config
    home-manager
    anki

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
