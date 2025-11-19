{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hyprlock;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprlock";
    };
    dm = lib.mkEnableOption "Hyprlock As The Display Manager";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock =
      {
        enable = true;
      }
      // {
        default = let
          foreground = "rgb(${lib.removePrefix "#" colors.foreground.base})";
          background = "rgb(${lib.removePrefix "#" colors.background.base})";
          accent = "rgb(${lib.removePrefix "#" colors.accent})";
          error = "rgb(${lib.removePrefix "#" colors.error})";
        in {
          settings = {
            general = {
              hide_cursor = true;
            };

            animations = {
              enabled = true;
              bezier = "linear, 1, 1, 0, 0";
              animation = [
                "fadeIn, 1, 8, linear"
                "fadeOut, 1, 3, linear"
                "inputFieldDots, 1, 1, linear"
              ];
            };

            background = {
              path = "~/.wall";
              blur_size = layout.blur.size;
              blur_passes = layout.blur.passes;
              vibrancy_darkness = 0;
            };

            label = [
              {
                text = "$TIME";
                font_size = 90;
                font_family = layout.font.name;
                color = foreground;
                position = "0, 300";
                halign = "center";
                valign = "center";
              }
              {
                text = "cmd[update:43200000] echo \"$(date +\"%A, %0d. %B %Y\")\"";
                font_size = 25;
                font_family = layout.font.name;
                color = foreground;
                position = "0, 220";
                halign = "center";
                valign = "center";
              }
            ];

            input-field = {
              size = "300, 60";
              outline_thickness = (lib.toInt layout.border.width) * 2;
              dots_size = 0.2;
              dots_spacing = 0.5;
              dots_center = true;
              fade_on_empty = false;
              hide_input = false;
              font_family = layout.font.name;
              placeholder_text = " $USER";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              position = "0, 100";
              halign = "center";
              valign = "center";

              outer_color = accent;
              inner_color = foreground;
              font_color = background;
              fail_color = error;
              check_color = accent;
            };
          };
        };
      }.${
        cfg.style
      };

    wayland.windowManager.hyprland.settings.exec-once =
      if cfg.dm == true
      then ["hyprlock"]
      else [];
  };
}
