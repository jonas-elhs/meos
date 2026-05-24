set -g __prompt_skip_newline 1

function mk_module -a color icon content
  printf "%s%s%s%s %s%s %s%s" \
    # Left seperator color
    (set_color $color -b normal) \
    # Icon color
    (set_color $color_background -b $color) \
    $icon \
    # Right icon seperator color
    (set_color $color -b $color_background_light) \
    # Content color
    (set_color $color_foreground -b $color_background_light) \
    $content \
    # Left seperator color
    (set_color $color_background_light -b normal) \
    (set_color --reset)
end

function fish_prompt
  if test -z "$__prompt_skip_newline"
    echo
  else
    set __prompt_skip_newline
  end

  source ~/.config/fish/update_color_vars.fish

  set -l reset_colors (set_color normal)

  set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
  set -l is_git (test -n "$git_root"; and echo 1; or echo 0)

  # DIRECTORY ICON
  set -l dir_icon ""
  if test $is_git -eq 1
    set dir_icon "󰊢"
  end

  # CURRENT DIRECTORY
  set -l dir $PWD
  if test $is_git -eq 1
    # Start at git root
    set -l repo_name (basename $git_root)
    set -l rel_path (string replace $git_root "" $dir)
    set dir "…/$repo_name$rel_path"
  else
    # Replace the home directory with "~"
    set dir (string replace -r "^$HOME" "~" $dir)
  end
  # Shorten path to at most 3 directories
  set dir (mk_module $color_base03 $dir_icon $dir)

  set -l git_branch
  set -l git_status
  if test $is_git -eq 1
    # GIT BRANCH
    set -l branch (git symbolic-ref --quiet --short HEAD 2>/dev/null; or printf "detached")
    set git_branch (mk_module $color_base04 "" $branch)

    # GIT STATUS
    set -l status_out (git status --porcelain 2>/dev/null)
    set -l icons

    # Staged/Added
    if string match -qr "^A" $status_out
      set -a icons ""
    end
    # Untracked
    if string match -qr "^\?" $status_out
      set -a icons ""
    end
    # Deleted
    if string match -qr "^D|^.D" $status_out
      set -a icons ""
    end
    # Modified
    if string match -qr "^M|^.M" $status_out
      set -a icons ""
    end
    # Renamed
    if string match -qr "^R" $status_out
      set -a icons ""
    end

    if test -n "$icons"
      set git_status " "(mk_module $color_base05 "" (string join " " $icons))
    end
  end

  # SPACE
  set -l space_width (math $COLUMNS - (string length --visible "$dir$git_branch$git_status"))
  if test $space_width -lt 0
    set space_width 0
  end
  set -l space (string repeat -n $space_width " ")

  printf "%s\n" "$dir$space$git_branch$git_status"
  printf " ➜ \n"
end

function fish_right_prompt
  set -l last_status $status

  set -l time
  if test $CMD_DURATION -gt 250
    if test $CMD_DURATION -lt 1000
      set time "$CMD_DURATION""ms"
    else if test $CMD_DURATION -lt 60000
      set -l seconds (printf "%.1f" (math "$CMD_DURATION / 1000"))
      set -l stripped (string replace -r '\.?0+$' "" $seconds)

      set time "$stripped""s"
    else
      set -l total_seconds (math --scale=0 "$CMD_DURATION / 1000")
      set -l minutes (math --scale=0 "$total_seconds / 60")
      set -l seconds (math --scale=0 "$total_seconds % 60")

      set time "$minutes""m" "$seconds""s"
    end
  end
  set time (set_color $color_background_light)$time(set_color normal)

  set -l fail
  if test $last_status -ne 0
    set fail (set_color $color_error --bold)" ✗"(set_color normal)
  end

  printf "%s" "$time$fail"
end

function fish_mode_prompt; end

alias clear="clear && set __prompt_skip_newline 1"
