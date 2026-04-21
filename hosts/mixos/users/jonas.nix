{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  layout = config.theme.layout;
in {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "system";
      font-size = lib.toInt layout.font.size;
      font-family = layout.font.mono;
      background-opacity = layout.background.opacity;

      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;

      adjust-cursor-thickness = "250%";
      adjust-underline-thickness = "25%";

      command = "fish";
      mouse-hide-while-typing = true;

      custom-shader = "~/.config/ghostty/shaders/cursor_warp.glsl";
    };
  };

  programs.metemplate = {
    enable = true;

    projects = {
      apple = {
        config = {
          values = ["color"];

          templates = {
            test = {
              file = "test.txt";
              out = "~/apple.txt";
            };
          };
        };

        values = {
          test = {
            color = "red";
          };
          test2 = {
            color = "green";
          };
        };

        templates = {
          "test.txt" = ''
            template: I like {{color}} apples;
          '';
        };
      };
    };
  };

  home.groups = ["wheel" "input"];
  home.fonts = with pkgs; [
    maple-nerd-font-mono
    maple-nerd-font-propo
  ];

  home.packages = with pkgs; [
    # krita
    hyprpicker
    material-symbols

    rustc
    cargo
    gcc
    gnumake
    cmake

    inputs.meshell.packages.x86_64-linux.cli
    inputs.mevim.packages.x86_64-linux.neovim

    nasm
    llvmPackages_latest.bintools-unwrapped

    lazygit

    uv

    teams-for-linux

    libnotify

    obs-studio

    jujutsu

    davinci-resolve

    mpv
    pkg-config
  ];

  theme = {
    layout = {
      border = {
        width = "2";
        radius = {
          size = "10";
          inner = "7";
        };
      };
      font = {
        name = "MapleMono Nerd Font Propo";
        mono = "MapleMono Nerd Font Mono";
        sub = "10";
        size = "12";
        title = "18";
      };
      background = {
        opacity = 0.4;
        opacity_hex = "66";
      };
      gap = {
        size = "20";
        inner = "10";
      };
      # css: filter: blur(calc(size * sqrt(passes) * 0.85px));
      blur = {
        size = "5";
        passes = "4";
      };
    };
  };

  qt.enable = true;

  programs.quickshell = {
    enable = true;
    activeConfig = "meshell";
    systemd.enable = true;
  };
  home.file.".config/quickshell/meshell".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/dev/meshell;
  home.file.".config/quickshell/meshell2".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/dev/meshell2;

  home.pointerCursor = {
    enable = true;

    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  nixpkgs.config.allowUnfree = true;

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
    vertical = true;
    plugins = [
      # inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
    ];
  };
  git = {
    enable = true;
    name = "jonas-elhs";
    email = "jonas.elhs@outlook.com";
  };

  hypridle = {
    enable = true;
    lockCommand = "meshell lock";
  };
  kitty.enable = true;
  starship.enable = true;
  zen.enable = true;
  anki.enable = true;

  # grim -g "$(slurp -w 0)" - | wl-copy
  programs.fish = {
    enable = true;
    shellInit = ''
      fish_vi_key_bindings
      set -g fish_autosuggestion_enabled 0
      set -g fish_greeting

      if not status is-login && test "$TERM" != "dumb"
        starship init fish | source
      end
    '';
  };

  programs.fuzzel.enable = true;
}
