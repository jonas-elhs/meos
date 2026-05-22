{
  lib,
  config,
  ...
}: let
  cfg = config.starship;
in {
  options.starship = {
    enable = lib.mkEnableOption "Starship Prompt";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.STARSHIP_CONFIG = lib.mkForce "${config.xdg.configHome}/starship.toml";
    programs.starship = let
      directory_color = "#EBCB8B";
      git_branch_color = "#81A1C1";
      git_status_color = "#BE9DB8";

      cmd_duration_color = "#434C5E";
    in {
      enable = true;
      configPath = "${config.xdg.configHome}/starship_nocolors.toml";
      enableFishIntegration = false;

      settings = {
        format = lib.concatStrings [
          "\${custom.folder_symbol}$directory"
          "$fill"
          "$git_branch $git_status"
          "$line_break $character"
        ];
        right_format = "$cmd_duration";
        continuation_prompt = "[┃]()";
        palette = "generated";

        custom.folder_symbol = {
          command = ''git rev-parse --is-inside-work-tree &>/dev/null && echo "󰊢" || echo ""'';
          format = "[](fg:${directory_color})[$output]($style)[](fg:${directory_color} bg:background)";
          style = "fg:icon bg:${directory_color}";
          when = true;
        };

        directory = {
          format = "[ $path ($read_only )]($style)[](fg:background)";
          style = "fg:foreground bg:background";
          read_only = "󰌾";
          truncation_symbol = "…/";
        };

        fill = {
          symbol = " ";
        };

        git_branch = {
          format = lib.concatStrings [
            "([](fg:${git_branch_color})[](fg:icon bg:${git_branch_color})[](fg:${git_branch_color} bg:background)"
            "[ $branch(:$remote_branch) ]($style)[](fg:background))"
          ];
          style = "fg:foreground bg:background";
        };

        git_status = {
          format = lib.concatStrings [
            "([](fg:${git_status_color})[](fg:icon bg:${git_status_color})[](fg:${git_status_color} bg:background)"
            "[( $staged)( $untracked)( $deleted)( $modified)( $renamed)( $stashed)"
            "( $conflicted)( $diverged)( $ahead)( $behind) ]($style)[](fg:background))"
          ];
          style = "fg:foreground bg:background";
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
          style = "fg:${cmd_duration_color}";
        };

        character = {
          success_symbol = "[➜](fg:foreground)";
          error_symbol = "[➜](fg:foreground)";
          vimcmd_symbol = "[➜](fg:foreground)";
          vimcmd_replace_symbol = "[➜](fg:foreground)";
          vimcmd_replace_one_symbol = "[➜](fg:foreground)";
          vimcmd_visual_symbol = "[➜](fg:foreground)";
        };
      };
    };
  };
}
