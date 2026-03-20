{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kitty;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.kitty = {
    enable = lib.mkEnableOption "Kitty Terminal";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Kitty Terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty =
      {
        enable = true;
      }
      // {
        default = {
          shellIntegration = {
            mode = "no-rc no-cursor";
          };
          font = {
            name = layout.font.mono;
            size = lib.toInt layout.font.size;
          };
          keybindings = {
            "ctrl+c" = "copy_or_interrupt";
            "ctrl+v" = "paste_from_clipboard";
          };
          settings = {
            background_opacity = layout.background.opacity;
            window_padding_width = 8;
            cursor_trail = 1;

            # Theme
            include = "colors.conf";
          };
        };
      }.${
        cfg.style
      };
  };
}
