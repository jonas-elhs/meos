{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fish;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.fish = {
    enable = lib.mkEnableOption "Fish Shell";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Fish Shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish =
      {
        enable = true;
      }
      // {
        default = {
          interactiveShellInit = ''
                 fish_vi_key_bindings default

                 function back_to_normal --on-event fish_prompt
            fish_vi_key_bindings default
                 end

                 set fish_cursor_default block
                 set fish_cursor_insert line
                 set fish_cursor_replace_one underscore
                 set fish_cursor_replace underscore
                 set fish_cursor_external line
                 set fish_cursor_visual block

                 set -g fish_autosuggestion_enabled 0
                 set -g fish_greeting
          '';
        };
      }.${
        cfg.style
      };

    programs.bash = {
      enable = true;
      initExtra = ''
        exec ${pkgs.fish}/bin/fish
      '';
    };
  };
}
