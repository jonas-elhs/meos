{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  layout = config.theme.layout;
in {
  ##############################
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

  home.username = "jonas";
  home.homeDirectory = "/home/jonas";
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
