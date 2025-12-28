{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.groups = ["wheel" "input"];
  home.fonts = with pkgs; [
    maple-nerd-font-mono
    maple-nerd-font-propo
  ];

  home.packages = with pkgs; [
    krita
    hyprpicker
    material-symbols

    rustc
    cargo
    gcc
    gnumake
    cmake

    inputs.meshell.packages.x86_64-linux.cli
    inputs.mevim.packages.x86_64-linux.nvim

    nasm
    llvmPackages_latest.bintools-unwrapped

    lazygit
  ];

  theme = {
    color = {
      name = "nordic";
      themes = "all";
    };
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
        opacity = 0.5;
        opacity_hex = "80";
      };
      gap = {
        size = "20";
        inner = "10";
      };
      blur = {
        size = "3";
        passes = "4";
      };
    };
  };

  programs.quickshell = {
    enable = true;
    activeConfig = "meshell";
    systemd.enable = true;
  };
  home.file.".config/quickshell/meshell".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/meshell;
  home.file.".config/nixCats-nvim".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/mevim;

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
  };

  nixpkgs.config.allowUnfree = true;

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
    vertical = true;
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
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
  fastfetch.enable = true;
  zen.enable = true;
  anki.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
    };

    history = {
      size = 10000;
    };

    initContent = ''
      if ! [[ -o login ]]; then
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi

      ZVM_SYSTEM_CLIPBOARD_ENABLED=true
      ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
    '';

    plugins = [
      {
        name = pkgs.zsh-vi-mode.pname;
        src = pkgs.zsh-vi-mode.src;
      }
    ];
  };

  programs.fuzzel.enable = true;
}
