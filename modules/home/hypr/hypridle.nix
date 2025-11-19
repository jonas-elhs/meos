{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hypridle;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.hypridle = {
    enable = lib.mkEnableOption "Hypridle";
    lockCommand = lib.mkOption {
      type = lib.types.str;
      description = "The command to run when the screen should be locked";
    };
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Hypridle";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle =
      {
        enable = true;
      }
      // {
        default = {
          settings = {
            general = {
              lock_cmd = cfg.lockCommand;
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
              # Lock System - 5 Minutes
              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }

              # Dim Screen - 20 Minutes
              {
                timeout = 1200;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }

              # Suspend System - 1 hour
              {
                timeout = 3600;
                on-timeout = "systemctl hibernate";
              }
            ];
          };
        };
      }.${
        cfg.style
      };
  };
}
