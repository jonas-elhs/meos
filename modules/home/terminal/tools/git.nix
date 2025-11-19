{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.git;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.git = {
    enable = lib.mkEnableOption "Git";
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The Name Of The Git User.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The Email Of The Git User.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = cfg.name;
          email = cfg.email;
        };
      };
    };
  };
}
