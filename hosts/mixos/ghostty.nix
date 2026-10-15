# TODO: update wrapper to support declaring shaders declaratively
# TODO: global toggle_quick_terminal
{
  wrappers.ghostty = {
    enable = true;

    settings = {
      theme = "system";
      font-size = 12;
      font-family = "Maple Mono NF";
      background-opacity = 0;

      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;

      adjust-cursor-thickness = "250%";
      adjust-underline-thickness = "25%";

      command = "fish";
      mouse-hide-while-typing = true;

      custom-shader = "~/dev/meos/dotfiles/ghostty_cursor_warp.glsl";
    };
  };
}
