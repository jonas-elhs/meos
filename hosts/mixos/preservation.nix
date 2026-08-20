{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];

      directories = [
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
        "/var/log"
      ];

      users.jonas = {
        files = [
          {
            file = ".config/hypr/colors.lua";
            how = "symlink";
          }
          {
            file = ".config/ghostty/themes/system";
            how = "symlink";
          }
          {
            file = ".config/fish/update_color_vars.fish";
            how = "symlink";
          }
        ];
        directories = [
          "dev"
          "wallpapers"
          "documents"
          ".local/state/wireplumber"
          ".cache/mozilla/firefox"
          ".config/mozilla/firefox"

          ".config/metemplate"
          ".config/nvim-colors/"
        ];
      };
    };
  };

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
