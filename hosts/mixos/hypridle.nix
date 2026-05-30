{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    (inputs.wrappers-hypridle.wrappers.hypridle.wrap {
      inherit pkgs;

      settings = {
        general = {
          lock_cmd = "meshell lock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
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
    })
  ];
}
