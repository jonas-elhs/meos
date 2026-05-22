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

  programs.quickshell = {
    enable = true;
    activeConfig = "meshell";
    systemd.enable = true;
  };
  home.file.".config/quickshell/meshell".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/dev/meshell;
  home.file.".config/quickshell/meshell2".source = config.lib.file.mkOutOfStoreSymlink /home/jonas/dev/meshell2;

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
    ];
  };

  hypridle = {
    enable = true;
    lockCommand = "meshell lock";
  };
  starship.enable = true;
  anki.enable = true;

  ##############################
  home.pointerCursor = {
    enable = true;

    # name = "googledot-black";
    # package = pkgs.google-cursor;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  home.username = "jonas";
  home.homeDirectory = "/home/jonas";
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
