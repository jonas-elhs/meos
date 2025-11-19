{
  config,
  pkgs,
  lib,
  libx,
  ...
}: let
  cfg = config.waybar;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options = {
    waybar.enable = lib.mkEnableOption "Waybar";
    waybar.style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Waybar";
    };
    waybar.gpu_hwmon = lib.mkOption {
      type = lib.types.int;
      default = null;
      description = "The hwmon number of the gpu";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar =
      {
        enable = true;
      }
      // {
        default = let
          accent = colors.accent;
          inactive = colors.inactive;
          text = colors.foreground.base;
          background = colors.background.base;

          text-size = "18";
          sub-size = "15";
        in {
          settings = {
            bar = {
              layer = "top";
              position = "top";
              margin = "${layout.gap.size} ${libx.stringDivide layout.gap.size 2} 0 ${libx.stringDivide layout.gap.size 2}";
              exclusive = true;

              modules-left = [
                #"group/apps"
                #"group/information"
                #"clock"
              ];
              modules-center = [
                "hyprland/workspaces"
              ];
              modules-right = [
                "group/hardware"
                "group/power"
              ];

              "group/apps" = {
                orientation = "inherit";
                modules = ["custom/launcher" "custom/terminal" "custom/browser" "custom/files" "custom/mail"];
                drawer = {
                  transition-duration = 300;
                  children-class = "bottom-drawer-sub-icon";
                  transition-left-to-right = true;
                };
              };
              "custom/launcher" = {
                format = "<span color='${accent}'></span>";
                tooltip = false;
                on-click = "walker";
              };
              "custom/terminal" = {
                format = "";
                tooltip-format = "Kitty";
                on-click = "kitty";
              };
              "custom/browser" = {
                format = "";
                tooltip-format = "Firefox";
                on-click = "firefox";
              };
              "custom/files" = {
                format = "";
                tooltip-format = "File Manager";
                on-click = "dolphin";
              };
              "custom/mail" = {
                format = "";
                tooltip-format = "Mail Client";
                on-click = "";
              };

              "group/information" = {
                orientation = "inherit";
                modules = ["network" "bluetooth" "wireplumber"];
              };
              network = {
                format-wifi = "<span color='${accent}'>{icon}</span>";
                tooltip-format-wifi = "{essid} ({signalStrength}%)";
                format-ethernet = "<span color='${accent}'></span>";
                tooltip-format-ethernet = "{ifname} ({bandwidthUpBits}  | {bandwidthDownBits} )";
                format-linked = "<span color='${accent}'></span>";
                tooltip-format-linked = "{ifname}";
                format-disconnected = "";
                format-icons = [
                  "󰤯"
                  "󰤟"
                  "󰤢"
                  "󰤥"
                  "󰤨"
                ];
              };
              bluetooth = {
                format-disabled = "";
                format-off = "<span color='${accent}'>󰂲</span>";
                format-on = "<span color='${accent}'>󰂯</span>";
                format-connected = "<span color='${accent}'>󰂯</span>";
                tooltip-format = "{num_connections} Devices";
                tooltip-format-off = "Off";
                on-click = "bluetooth-toggle";
              };
              wireplumber = {
                format = "<span color='${accent}'>{icon}</span>";
                format-low = "<span color='${accent}'>x</span> {volume}%"; # not working
                format-none = "<span color='${accent}'>x</span> {volume}%"; # not working
                format-muted = "<span color='${accent}'></span>";
                tooltip-format = "{volume}%";
                on-click = "audio-toggle";

                format-icons = ["" "" ""];

                states = {
                  none = 0;
                  low = 50;
                };
              };

              clock = {
                format = "<span color='${accent}'></span> {:%H:%M}";
                tooltip-format = "{:%A, %d. %B %Y}";
                justify = "center";
                expand = true;
              };

              "hyprland/workspaces" = {
                format = "";
                on-click = "activate";
                on-scroll-up = "hyprctl dispatch workspace e+1";
                on-scroll-down = "hyprctl dispatch workspace e-1";
              };

              "group/hardware" = {
                orientation = "inherit";
                modules = ["cpu" "custom/gpu" "memory" "disk"];
              };
              cpu = {
                format = "<span color='${accent}'></span> {usage}%";
                tooltip-format = "{load}";
                justify = "center";
                align = "left";
                expand = true;
              };
              "custom/gpu" = {
                format = "<span color='${accent}'>󰢮</span> {}%";
                exec = "cat /sys/class/hwmon/hwmon${toString cfg.gpu_hwmon}/device/gpu_busy_percent";
                tooltip = false;
                interval = 1;
                justify = "center";
                align = "left";
                expand = true;
              };
              memory = {
                format = "<span color='${accent}'></span> {percentage}%";
                tooltip-format = "{used:0.1f} GiB / {total:0.1f} GiB";
                justify = "center";
                align = "left";
                expand = true;
              };
              disk = {
                format = "<span color='${accent}'></span> {percentage_used}%";
                tooltip-format = "{specific_used:0.1f} GB / {specific_total:0.1f} GB";
                unit = "GB";
                justify = "center";
                align = "left";
                expand = true;
              };

              "group/power" = {
                orientation = "inherit";
                modules = ["custom/shutdown" "custom/suspend" "custom/hibernate" "custom/logout" "custom/lock" "custom/reboot"];
                drawer = {
                  transition-duration = 300;
                  children-class = "top-drawer-sub-icon";
                  transition-left-to-right = false;
                };
              };
              "custom/shutdown" = {
                format = "<span color='${accent}'>⏻</span>";
                on-click = "systemctl poweroff";
                tooltip-format = "Shutdown";
              };
              "custom/reboot" = {
                format = "";
                on-click = "systemctl reboot";
                tooltip-format = "Reboot";
              };
              "custom/lock" = {
                format = "";
                on-click = "loginctl lock-session";
                tooltip-format = "Lock";
              };
              "custom/logout" = {
                format = "󰍃";
                on-click = "hyprctl dispatch exit";
                tooltip-format = "Logout";
              };
              "custom/hibernate" = {
                format = "";
                on-click = "systemctl hibernate";
                tooltip-format = "Hibernate";
              };
              "custom/suspend" = {
                format = "";
                on-click = "systemctl suspend";
                tooltip-format = "Suspend";
              };
            };
          };

          style = ''
            * {
              font-family: ${layout.font.name};
              font-size: ${text-size}px;
              min-height: 0;
              background: transparent;
              border: none;
              color: ${text};
            }

            /* Visual Groups */
            #apps,
            #information,
            #clock,
            #workspaces,
            #hardware,
            #power,
            tooltip label {
              background: alpha(${background}, ${toString layout.background.opacity});
              padding: ${layout.gap.inner}px;
              margin: 0px ${libx.stringDivide layout.gap.size 2}px;
              border: ${layout.border.width}px solid ${inactive};
              border-radius: ${layout.border.radius.size}px;
              transition: border 0.2s ease;
            }
            #apps:hover,
            #information:hover,
            #clock:hover,
            #workspaces:hover,
            #hardware:hover,
            #power:hover {
              border: ${layout.border.width}px solid ${accent};
            }

            /* Tooltips Border */
            tooltip label {
              border: ${layout.border.width}px solid ${accent};
            }

            /* Drawers */
            .bottom-drawer-sub-icon label {
              font-size: ${sub-size}px;
              margin: 0px 0px 0px ${layout.gap.inner}px;
            }
            .top-drawer-sub-icon label {
              font-size: ${sub-size}px;
              margin: 0px ${layout.gap.inner}px 0px 0px;
            }

            /* Groups */
            #hardware,
            #information {
              padding: ${layout.gap.inner}px ${libx.stringDivide layout.gap.inner 2}px;
            }
            #hardware label,
            #information label {
              margin: 0px ${libx.stringDivide layout.gap.inner 2}px;
            }

            /* None Padded Groups */
            #hardware {
              padding: 0px ${libx.stringDivide layout.gap.inner 2}px;
            }

            /* Workspaces */
            #workspaces {
              padding: ${layout.gap.inner}px ${libx.stringDivide layout.gap.inner 2}px;
            }
            #workspaces button {
              background: ${text};
              padding: 0px 0px;
              margin: 3px ${libx.stringDivide layout.gap.inner 2}px;
              transition: padding 0.2s ease;
              border-radius: 10px;
              border: none;
            }
            #workspaces button:hover {
              background: ${text};
              border: none;
              box-shadow: none;
            }
            #workspaces button.active {
              background: ${accent};
              padding: 0px 30px;
            }
            #workspaces button.active:hover {
              background: ${accent};
            }
            #workspaces button label {
              font-size: 12px;
            }
          '';
        };
        vertical = let
          accent = colors.accent;
          inactive = colors.inactive;
          text = colors.foreground.base;
          background = colors.background.base;

          text-size = "18";
          sub-size = "15";
        in {
          settings = {
            bar = {
              layer = "top";
              position = "right";
              #margin = "${libx.stringDivide layout.gap.size 2} 0 ${libx.stringDivide layout.gap.size 2} ${layout.gap.size}";
              margin = "${libx.stringDivide layout.gap.size 2} ${layout.gap.size} ${libx.stringDivide layout.gap.size 2} 0";
              exclusive = true;

              modules-left = [
                "group/apps"
                "group/information"
                "clock"
              ];
              modules-center = [
                "hyprland/workspaces"
              ];
              modules-right = [
                "group/hardware"
                "group/power"
              ];

              "group/apps" = {
                orientation = "inherit";
                modules = ["custom/launcher" "custom/terminal" "custom/browser" "custom/files" "custom/mail"];
                drawer = {
                  transition-duration = 300;
                  children-class = "bottom-drawer-sub-icon";
                  transition-left-to-right = true;
                };
              };
              "custom/launcher" = {
                format = "<span color='${accent}'></span>";
                tooltip = false;
                on-click = "walker";
              };
              "custom/terminal" = {
                format = "";
                tooltip-format = "Kitty";
                on-click = "kitty";
              };
              "custom/browser" = {
                format = "";
                tooltip-format = "Firefox";
                on-click = "firefox";
              };
              "custom/files" = {
                format = "";
                tooltip-format = "File Manager";
                on-click = "dolphin";
              };
              "custom/mail" = {
                format = "";
                tooltip-format = "Mail Client";
                on-click = "";
              };

              "group/information" = {
                orientation = "inherit";
                modules = ["network" "bluetooth" "wireplumber"];
              };
              network = {
                format-wifi = "<span color='${accent}'>{icon}</span>";
                tooltip-format-wifi = "{essid} ({signalStrength}%)";
                format-ethernet = "<span color='${accent}'></span>";
                tooltip-format-ethernet = "{ifname} ({bandwidthUpBits}  | {bandwidthDownBits} )";
                format-linked = "<span color='${accent}'></span>";
                tooltip-format-linked = "{ifname}";
                format-disconnected = "";
                format-icons = [
                  "󰤯"
                  "󰤟"
                  "󰤢"
                  "󰤥"
                  "󰤨"
                ];
              };
              bluetooth = {
                format-disabled = "";
                format-off = "<span color='${accent}'>󰂲</span>";
                format-on = "<span color='${accent}'>󰂯</span>";
                format-connected = "<span color='${accent}'>󰂯</span>";
                tooltip-format = "{num_connections} Devices";
                tooltip-format-off = "Off";
                on-click = "bluetooth-toggle";
              };
              wireplumber = {
                format = "<span color='${accent}'>{icon}</span>";
                format-low = "<span color='${accent}'>x</span> {volume}%"; # not working
                format-none = "<span color='${accent}'>x</span> {volume}%"; # not working
                format-muted = "<span color='${accent}'></span>";
                tooltip-format = "{volume}%";
                on-click = "audio-toggle";

                format-icons = ["" "" ""];

                states = {
                  none = 0;
                  low = 50;
                };
              };

              clock = {
                format = "<span color='${accent}'></span>\n{:%H\n%M}";
                tooltip-format = "{:%A, %d. %B %Y}";
                justify = "center";
                expand = true;
              };

              "hyprland/workspaces" = {
                format = "";
                on-click = "activate";
                on-scroll-up = "hyprctl dispatch workspace e-1";
                on-scroll-down = "hyprctl dispatch workspace e+1";
              };

              "group/hardware" = {
                orientation = "inherit";
                modules = ["cpu" "custom/gpu" "memory" "disk"];
              };
              cpu = {
                format = "<span color='${accent}'></span>\n{usage}%";
                tooltip-format = "{load}";
                justify = "center";
                align = "left";
                expand = true;
              };
              "custom/gpu" = {
                format = "<span color='${accent}'>󰢮</span>\n{}%";
                exec = "cat /sys/class/hwmon/hwmon${toString cfg.gpu_hwmon}/device/gpu_busy_percent";
                tooltip = false;
                interval = 1;
                justify = "center";
                align = "left";
                expand = true;
              };
              memory = {
                format = "<span color='${accent}'></span>\n{percentage}%";
                tooltip-format = "{used:0.1f} GiB / {total:0.1f} GiB";
                justify = "center";
                align = "left";
                expand = true;
              };
              disk = {
                format = "<span color='${accent}'></span>\n{percentage_used}%";
                tooltip-format = "{specific_used:0.1f} GB / {specific_total:0.1f} GB";
                unit = "GB";
                justify = "center";
                align = "left";
                expand = true;
              };

              "group/power" = {
                orientation = "inherit";
                modules = ["custom/shutdown" "custom/suspend" "custom/hibernate" "custom/logout" "custom/lock" "custom/reboot"];
                drawer = {
                  transition-duration = 300;
                  children-class = "top-drawer-sub-icon";
                  transition-left-to-right = false;
                };
              };
              "custom/shutdown" = {
                format = "<span color='${accent}'>⏻</span>";
                on-click = "systemctl poweroff";
                tooltip-format = "Shutdown";
              };
              "custom/reboot" = {
                format = "";
                on-click = "systemctl reboot";
                tooltip-format = "Reboot";
              };
              "custom/lock" = {
                format = "";
                on-click = "loginctl lock-session";
                tooltip-format = "Lock";
              };
              "custom/logout" = {
                format = "󰍃";
                on-click = "hyprctl dispatch exit";
                tooltip-format = "Logout";
              };
              "custom/hibernate" = {
                format = "";
                on-click = "systemctl hibernate";
                tooltip-format = "Hibernate";
              };
              "custom/suspend" = {
                format = "";
                on-click = "systemctl suspend";
                tooltip-format = "Suspend";
              };
            };
          };

          style = ''
            * {
              font-family: ${layout.font.name};
              font-size: ${text-size}px;
              min-height: 0;
              background: transparent;
              border: none;
              color: ${text};
            }

            /* Visual Groups */
            #apps,
            #information,
            #clock,
            #workspaces,
            #hardware,
            #power,
            tooltip label {
              background: alpha(${background}, ${toString layout.background.opacity});
              padding: ${layout.gap.inner}px;
              margin: ${libx.stringDivide layout.gap.size 2}px 0px;
              border: ${layout.border.width}px solid ${inactive};
              border-radius: ${layout.border.radius.size}px;
              transition: border 0.2s ease;
            }
            #apps:hover,
            #information:hover,
            #clock:hover,
            #workspaces:hover,
            #hardware:hover,
            #power:hover {
              border: ${layout.border.width}px solid ${accent};
            }

            /* Tooltips Border */
            tooltip label {
              border: ${layout.border.width}px solid ${accent};
            }

            /* Drawers */
            .bottom-drawer-sub-icon label {
              font-size: ${sub-size}px;
              margin: ${layout.gap.inner}px 0px 0px 0px;
            }
            .top-drawer-sub-icon label {
              font-size: ${sub-size}px;
              margin: 0px 0px ${layout.gap.inner}px 0px;
            }

            /* Groups */
            #hardware,
            #information {
              padding: ${libx.stringDivide layout.gap.inner 2}px ${layout.gap.inner}px;
            }
            #hardware label,
            #information label {
              margin: ${libx.stringDivide layout.gap.inner 2}px 0px;
            }

            /* None Padded Groups */
            #hardware {
              padding: ${libx.stringDivide layout.gap.inner 2}px 0px;
            }

            /* Workspaces */
            #workspaces {
              padding: ${libx.stringDivide layout.gap.inner 2}px ${layout.gap.inner}px;
            }
            #workspaces button {
              background: ${text};
              padding: 0px 0px;
              margin: ${libx.stringDivide layout.gap.inner 2}px 3px;
              transition: padding 0.2s ease;
              border-radius: 10px;
              border: none;
            }
            #workspaces button:hover {
              background: ${text};
              border: none;
              box-shadow: none;
            }
            #workspaces button.active {
              background: ${accent};
              padding: 30px 0px;
            }
            #workspaces button.active:hover {
              background: ${accent};
            }
            #workspaces button label {
              font-size: 12px;
            }
          '';
        };
      }.${
        cfg.style
      };
  };
}
