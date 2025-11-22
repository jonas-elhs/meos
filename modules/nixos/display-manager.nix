{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.display-manager;
in {
  options.display-manager = {
    autologin.enable = lib.mkEnableOption "Auto Login";
    autologin.user = lib.mkOption {
      type = lib.types.str;
      description = "The user to log in to.";
    };
    autologin.command = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The command to run on login.";
    };
  };

  config = {
    services.greetd = {
      enable = cfg.autologin.enable;
      settings = rec {
        initial_session = {
          command = cfg.autologin.command;
          user = cfg.autologin.user;
        };
        default_session = initial_session;
      };
    };
  };
}
