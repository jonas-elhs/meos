{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hyprpaper;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The path to the wallpaper for all monitors.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = cfg.wallpaper;
        wallpaper = ", ${cfg.wallpaper}";
      };
    };

    home.packages = with pkgs; [
      hyprpaper

      (writeShellApplication rec {
        name = "wall";
        text = ''
          if [[ $# -ne 1 ]]; then
            echo "Usage: ${name} <wallpaper path>"
            exit 1
          fi

          hyprctl hyprpaper reload ",$1"
        '';
      })
    ];
  };
}
