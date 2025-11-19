{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.home = {
    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The groups of a user";
    };
    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "All fonts to install on the system.";
    };
  };

  config = {
    fonts.fontconfig.enable = true;

    home.packages = cfg.fonts;
  };
}
