{
  lib,
  pkgs,
  config,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        user = config.preferences.username;
        command = "${lib.getExe pkgs.uwsm} start hyprland.desktop";
      };
      default_session = initial_session;
    };
  };
}
