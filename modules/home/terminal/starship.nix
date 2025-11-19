{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.starship;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.starship = {
    enable = lib.mkEnableOption "Starship Prompt";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Starship Prompt";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship =
      {
        enable = true;
        enableZshIntegration = false;
        # enableFishIntegration = true;
      }
      // {
        default = let
          directory = lib.elemAt colors.gradient3 0;
          git_branch = lib.elemAt colors.gradient3 1;
          git_status = lib.elemAt colors.gradient3 2;

          icon = colors.background.base;
          background = colors.background.light;
          foreground = colors.foreground.base;
          cmd_duration = colors.foreground.dark;
        in {
          settings = {
            format = lib.concatStrings [
              "\${custom.folder_symbol}$directory"
              "$fill"
              "$git_branch $git_status"
              "$line_break $character"
            ];
            right_format = "$cmd_duration";
            continuation_prompt = "[┃]()";

            custom.folder_symbol = {
              command = ''git rev-parse --is-inside-work-tree &>/dev/null && echo "󰊢" || echo ""'';
              format = "[](fg:${directory})[$output]($style)[](fg:${directory} bg:${background})";
              style = "fg:${icon} bg:${directory}";
              when = true;
            };

            directory = {
              format = "[ $path ($read_only )]($style)[](fg:${background})";
              style = "fg:${foreground} bg:${background}";
              read_only = "󰌾";
              truncation_symbol = "…/";
            };

            fill = {
              symbol = " ";
            };

            git_branch = {
              format = lib.concatStrings [
                "([](fg:${git_branch})[](fg:${icon} bg:${git_branch})[](fg:${git_branch} bg:${background})"
                "[ $branch(:$remote_branch) ]($style)[](fg:${background}))"
              ];
              style = "fg:${foreground} bg:${background}";
            };

            git_status = {
              format = lib.concatStrings [
                "([](fg:${git_status})[](fg:${icon} bg:${git_status})[](fg:${git_status} bg:${background})"
                "[( $staged)( $untracked)( $deleted)( $modified)( $renamed)( $stashed)"
                "( $conflicted)( $diverged)( $ahead)( $behind) ]($style)[](fg:${background}))"
              ];
              style = "fg:${foreground} bg:${background}";
              staged = "";
              untracked = "";
              deleted = "";
              modified = "";
              renamed = "";
              stashed = "";
              conflicted = "";
              diverged = "⇕";
              ahead = "⇡";
              behind = "⇣";
            };

            cmd_duration = {
              format = "[$duration]($style)";
              style = "fg:${cmd_duration}";
            };

            character = {
              success_symbol = "[➜](fg:${foreground})";
              error_symbol = "[➜](fg:${foreground})";
              vimcmd_symbol = "[➜](fg:${foreground})";
              vimcmd_replace_symbol = "[➜](fg:${foreground})";
              vimcmd_replace_one_symbol = "[➜](fg:${foreground})";
              vimcmd_visual_symbol = "[➜](fg:${foreground})";
            };
          };
        };
      }.${
        cfg.style
      };
  };
}
