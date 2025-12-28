{
  config,
  pkgs,
  lib,
  libx,
  inputs,
  ...
}: let
  cfg = config.hyprland;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hyprland";
    };
    vertical = lib.mkEnableOption "Vertical Workspaces";
    persistentWorkspaces = lib.mkOption {
      type = lib.types.int;
      default = 0;
      example = 5;
      description = "The amount of persistent workspaces to have";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Plugins to add to hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland =
      {
        enable = true;
        plugins = cfg.plugins;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      }
      // {
        default = let
          active = "rgba(${lib.removePrefix "#" colors.accent}ee)";
          inactive = "rgba(${lib.removePrefix "#" colors.inactive}ee)";
          dark-background = lib.removePrefix "#" colors.background.dark;
        in {
          settings = {
            debug = {
              disable_logs = false;
            };

            # ---------- MONITORS ---------- #
            monitor = [
              "HDMI-A-2, 3840x2160@60, 0x0, 1.5"
            ];

            workspace = builtins.genList (n: "${toString (n + 1)}, persistent:true") cfg.persistentWorkspaces;

            # ---------- PROGRAMS ---------- #
            "$terminal" = "kitty";
            "$fileManager" = "dolphin";
            "$appLauncher" = "fuzzel";
            "$themeSwitcher" = "walker --modules themes";
            "$wallpaperSwitcher" = "walker --modules wallpapers";
            "$browser" = "zen-twilight";

            # ---------- AUTOSTART ---------- #
            exec-once = [
              "sleep 1 && meshell lock"
              "wl-paste --type text --watch cliphist store"
              "wl-paste --type image --watch cliphist store"
            ];

            # ---------- ENVIRONMENT VARIABLES ---------- #
            env = [];

            # ---------- LAYOUTS ----------- #
            master = {
              mfact = 0.65;
            };

            # ---------- PLUGINS ---------- #
            plugin = {
              dynamic-cursors = {
                enabled = true;
                mode = "stretch";
                threshhold = 2;

                shake = {
                  enabled = false;
                };
              };
            };

            # ---------- LOOK AND FEEL ---------- #
            general = {
              border_size = layout.border.width;

              gaps_in = libx.stringDivide layout.gap.size 2;
              gaps_out = layout.gap.size;

              "col.active_border" = active;
              "col.inactive_border" = inactive;

              layout = "master";
            };

            decoration = {
              rounding = layout.border.radius.size;
              rounding_power = 2.0;

              layerrule = [
                "blur true, match:namespace meshell-shell"
                "ignore_alpha 0, match:namespace meshell-shell"
              ];

              shadow = {
                enabled = true;
                range = 15;
                render_power = 3;
                color = "rgba(${dark-background}ee)";
              };
              blur = {
                enabled = true;
                size = layout.blur.size;
                passes = layout.blur.passes;
                vibrancy = 0.1696;
                popups = true;
              };
            };

            animations = {
              enabled = true;

              animation = [
                "workspaces, 1, 5, default, ${
                  if cfg.vertical == false
                  then "slide"
                  else "slidevert"
                }"
                "border, 1, 2, linear"
              ];
            };

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              session_lock_xray = true;
            };

            # ---------- INPUT --------- #
            input = {
              follow_mouse = 1;
              sensitivity = 0.0;
            };

            # ---------- KEYBINDINGS ---------- #
            "$prefix" = "SUPER";

            bind = [
              "$prefix, t, global, meshell:test"
              "$prefix, s, global, meshell:bar"
              "$prefix, p, global, meshell:powerMenu"
              "$prefix, c, global, meshell:pickHexColorCopy"

              # General
              "$prefix, Return, exec, uwsm app -- $terminal"
              "$prefix, B, exec, uwsm app -- $browser"
              "$prefix, Y, exec, uwsm app -- firefox"
              "$prefix, R, exec, $appLauncher"
              "$prefix SHIFT, T, exec, $themeSwitcher"
              "$prefix SHIFT, W, exec, $wallpaperSwitcher"
              "$prefix, E, exec, $fileManager"

              "$prefix, Q, killactive,"
              "$prefix SHIFT, Q, exit,"

              "$prefix, V, togglefloating,"
              "$prefix, F, fullscreen, 1"
              "$prefix SHIFT, F, fullscreen, 0"

              # Utils
              #"$prefix SHIFT, L, exec, loginctl lock-session"
              "$prefix SHIFT, S, exec, screenshot"

              # Layouts
              "$prefix, M, layoutmsg, swapwithmaster"

              # Move Window Focus
              "$prefix, H, movefocus, l"
              "$prefix, J, movefocus, d"
              "$prefix, K, movefocus, u"
              "$prefix, L, movefocus, r"

              # Move Window
              "$prefix SHIFT, H, movewindow, l"
              "$prefix SHIFT, J, movewindow, d"
              "$prefix SHIFT, K, movewindow, u"
              "$prefix SHIFT, L, movewindow, r"

              # Switch Workspaces
              "$prefix, 1, workspace, 1"
              "$prefix, 2, workspace, 2"
              "$prefix, 3, workspace, 3"
              "$prefix, 4, workspace, 4"
              "$prefix, 5, workspace, 5"
              "$prefix, 6, workspace, 6"
              "$prefix, 7, workspace, 7"
              "$prefix, 8, workspace, 8"
              "$prefix, 9, workspace, 9"
              "$prefix, 0, workspace, 10"

              # Move Window To Workspace
              "$prefix SHIFT, 1, movetoworkspace, 1"
              "$prefix SHIFT, 2, movetoworkspace, 2"
              "$prefix SHIFT, 3, movetoworkspace, 3"
              "$prefix SHIFT, 4, movetoworkspace, 4"
              "$prefix SHIFT, 5, movetoworkspace, 5"
              "$prefix SHIFT, 6, movetoworkspace, 6"
              "$prefix SHIFT, 7, movetoworkspace, 7"
              "$prefix SHIFT, 8, movetoworkspace, 8"
              "$prefix SHIFT, 9, movetoworkspace, 9"
              "$prefix SHIFT, 0, movetoworkspace, 10"
            ];
            binde = [
              # Resize Window
              "$prefix CTRL, H, resizeactive, -10 0"
              "$prefix CTRL, J, resizeactive, 0 10"
              "$prefix CTRL, K, resizeactive, 0 -10"
              "$prefix CTRL, L, resizeactive, 10 0"
            ];
            bindm = [
              # Move & Resize Windows Mouse
              "$prefix, mouse:272, movewindow"
              "$prefix, mouse:273, resizewindow"
            ];
          };
        };
      }.${
        cfg.style
      };
  };
}
