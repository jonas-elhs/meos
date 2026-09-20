# TODO: update wrapper to support declaring shaders declaratively
{
  pkgs,
  wrappers,
  ...
}: {
  environment.systemPackages = [
    (wrappers.ghostty.wrap {
      inherit pkgs;

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
    })
  ];
}
