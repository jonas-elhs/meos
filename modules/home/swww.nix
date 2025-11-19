{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.swww;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.swww = {
    enable = lib.mkEnableOption "SWWW";
  };

  config = lib.mkIf cfg.enable {
    services.swww = {
      enable = true;
      package = pkgs.swww;
    };

    home.packages = with pkgs; [
      (writeShellApplication rec {
        name = "wall";
        text = ''
          if [[ $# -ne 1 ]]; then
            echo "Usage: ${name} <wallpaper path>"
            exit 1
          fi

          swww img \
            --transition-type grow \
            --transition-pos top-right \
            --transition-duration 2.5 \
            --transition-bezier .25,.1,.25,1 \
            --transition-fps 60 \
            "$1"
        '';
      })
    ];
  };
}
