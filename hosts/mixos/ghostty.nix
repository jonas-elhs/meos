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

        custom-shader = "~/.config/ghostty/shaders/cursor_warp.glsl";
      };
    })
  ];
}
