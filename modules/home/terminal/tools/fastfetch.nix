{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fastfetch;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.fastfetch = {
    enable = lib.mkEnableOption "Fastfetch";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Fastfetch";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch =
      {
        enable = true;
      }
      // {
        default = let
          hardware = lib.elemAt colors.gradient3 0;
          software = lib.elemAt colors.gradient3 1;
          software2 = lib.elemAt colors.gradient3 2;

          text = colors.foreground;
        in {
          settings = {
            logo = {
              padding = {
                top = 0;
              };
            };

            display = {
              size = {
                binaryPrefix = "si";
              };
              color = {
                output = text;
              };
              key = {
                width = 14;
              };
            };

            modules = [
              {
                type = "custom";
                format = "┌──────────────────────Hardware──────────────────────┐";
              }
              {
                type = "host";
                keyColor = hardware;
              }
              {
                type = "cpu";
                format = "{name} ({cores-online} Cores | {freq-base})";
                keyColor = hardware;
              }
              {
                type = "gpu";
                format = "{vendor} {name} ({core-count} Cores | {frequency} | {dedicated-total})";
                driverSpecific = true;
                hideType = "integrated";
                keyColor = hardware;
              }
              {
                type = "memory";
                format = "{total}";
                keyColor = hardware;
              }
              {
                type = "disk";
                format = "{size-total} - {filesystem}";
                showExternal = false;
                keyColor = hardware;
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────────────────┘";
              }

              "break"

              {
                type = "custom";
                format = "┌──────────────────────Software──────────────────────┐";
              }
              {
                type = "os";
                format = "{name} {version-id}";
                keyColor = software;
              }
              {
                type = "kernel";
                keyColor = software;
              }
              {
                type = "initsystem";
                keyColor = software;
              }
              {
                type = "bootmgr";
                keyColor = software;
              }
              {
                type = "packages";
                keyColor = software;
              }

              "break"

              {
                type = "lm";
                keyColor = software2;
              }
              {
                type = "de";
                keyColor = software2;
              }
              {
                type = "wm";
                keyColor = software2;
              }
              {
                type = "font";
                keyColor = software2;
              }
              {
                type = "terminal";
                keyColor = software2;
              }
              {
                type = "editor";
                keyColor = software2;
              }
              {
                type = "shell";
                keyColor = software2;
              }
              {
                type = "custom";
                format = "└────────────────────────────────────────────────────┘";
              }

              "break"

              {
                type = "colors";
                symbol = "circle";
              }
            ];
          };
        };
      }.${
        cfg.style
      };
  };
}
