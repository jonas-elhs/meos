{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.XXX;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.XXX = {
    enable = lib.mkEnableOption "XXX";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of XXX";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.XXX =
      {
        enable = true;
      }
      // {
        default = {
        };
      }.${
        cfg.style
      };
  };
}
